unit HST3DGridLayer;

interface

uses ANE_LayerUnit;

type

TActiveCell = Class(T_ANE_GridParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TKxGridParam = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TKyGridParam = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TKzGridParam = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TPorosityParameter = Class(T_ANE_GridParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TVerticalCompParameter = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

THeatCapacityParameter = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TXConductivityParameter = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TYConductivityParameter = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TZConductivityParameter = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TLongDispParameter = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TTransDispParameter = Class(T_ANE_GridParam)
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TDistCoefParameter = Class(T_ANE_GridParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TLayerElevationParameter = Class(T_ANE_GridParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TT0Parameter = Class(T_ANE_GridParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TW0Parameter = Class(T_ANE_GridParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TObsElevGridParameter = Class(T_ANE_GridParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TGridUnitParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer); override;
  end;

TGridNLParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer); override;
  end;

THST3DGridLayer = Class(T_ANE_GridLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;


THST3DNodeGridLayer = Class(T_ANE_GridLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;


const
  kGridActive : string = 'Active Element Layer';
  kGridKx : string = 'Kx Element Layer';
  kGridKy : string = 'Ky Element Layer';
  kGridKz : string = 'Kz Element Layer';
  kGridPor : string = 'Porosity Element Layer';
  kGridVertComp : string = 'Vertical Compr Element Layer';
  kGridHeat : string = 'Heat Cap Element Layer';
  kGridXCond : string = 'X Thermal Conductivity Element Layer';
  kGridYCond : string = 'Y Thermal Conductivity Element Layer';
  kGridZCond : string = 'Z Thermal Conductivity Element Layer';
  kGridLongDisp : string = 'Longitudinal Dispersivity Element Layer';
  kGridTransDisp : string = 'Transverse Dispersivity Element Layer';
  kGridDist : string = 'Distribution Coef Element Layer';
  kElevation : string = 'Elevation NL';
  kT0 : string = 'T0';
  kW0 : string = 'W0';
  kGridLayer : string = 'HST3D Grid';
  kObsElevation : string = 'Observation Elevation Nodes';
  kGridNodeLayer : string = 'HST3D Node Grid';



implementation

uses SysUtils, HST3DUnit, HST3DActiveAreaLayers, HST3DPermeabilityLayers,
     HST3DPorosityLayers, HST3DThermCondLayers, HST3DDispersivityLayers,
     HST3DDistCoefLayers, HST3D_PIE_Unit, HST3DVertCompLayers,
     HST3DHeatCapacityLayers, HST3DDomainDensityLayers,
     HST3DObservationElevations ;

{ TActiveCell }
constructor TActiveCell.Create(AParameterList : T_ANE_ParameterList; Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

class Function TActiveCell.ANE_ParamName : string ;
begin
  result := kGridActive;
end;

function TActiveCell.Value : string;
begin
  result := 'If(IsNA(DefaultValue(' + kActiveAreaUnit + WriteIndex
    + ')), (BlockIsActive()&(' + kActiveAreaUnit + WriteIndex
    + '!=0)&(IsNA(' + kActiveAreaUnit + WriteIndex
    + '))), (BlockIsActive()&(' + kActiveAreaUnit + WriteIndex  + ')))'
end;

{ TKxGridParam }
function TKxGridParam.Units : string;
begin
  result := 'm^2 or ft^2';
end;

class Function TKxGridParam.ANE_ParamName : string ;
begin
  result := kGridKx;
end;

{constructor TKxGridParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm^2 or ft^2';
end;}

function TKxGridParam.Value : string;
begin
  result := kPermUnit + WriteIndex + '.' + kPermKx;
end;

{ TKyGridParam }
function TKyGridParam.Units : string;
begin
  result := 'm^2 or ft^2';
end;

class Function TKyGridParam.ANE_ParamName : string ;
begin
  result := kGridKy;
end;

function TKyGridParam.Value : string;
begin
  result := kPermUnit + WriteIndex + '.' + kPermKy;
end;

{constructor TKyGridParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm^2 or ft^2';
end;}

{ TKzGridParam }
function TKzGridParam.Units : string;
begin
  result := 'm^2 or ft^2';
end;

class Function TKzGridParam.ANE_ParamName : string ;
begin
  result := kGridKz;
end;

function TKzGridParam.Value : string;
begin
  result := kPermUnit + WriteIndex + '.' + kPermKz;
end;

{constructor TKzGridParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm^2 or ft^2';
end;}

{ TPorosityParameter }
class Function TPorosityParameter.ANE_ParamName : string ;
begin
  result := kGridPor;
end;

function TPorosityParameter.Value : string;
begin
  result := kPorosityUnit + WriteIndex;
end;

{ TVerticalCompParameter }
function TVerticalCompParameter.Units : string;
begin
  result := 'Pa^-1 or psi^-1';
end;

class Function TVerticalCompParameter.ANE_ParamName : string ;
begin
  result := kGridVertComp;
end;

function TVerticalCompParameter.Value : string;
begin
  result := kVertComp + WriteIndex;
end;

{constructor TVerticalCompParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Units := 'Pa^-1 or psi^-1';
end;}

{ THeatCapacityParameter }
function THeatCapacityParameter.Units : string;
begin
  result := 'J/m^3-C or BTU/ft^3-F';
end;

class Function THeatCapacityParameter.ANE_ParamName : string ;
begin
  result := kGridHeat;
end;

function THeatCapacityParameter.Value : string;
begin
  result := kHeatCap + WriteIndex;
end;

{constructor THeatCapacityParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Units := 'J/m^3-C or BTU/ft^3-F';
end;}

{ TXConductivityParameter }
function TXConductivityParameter.Units : string;
begin
  result := 'W/m-C or BTU/ft-h-F';
end;

class Function TXConductivityParameter.ANE_ParamName : string ;
begin
  result := kGridXCond;
end;

function TXConductivityParameter.Value : string;
begin
  result := kThermLayer + WriteIndex + '.' + kThermX;
end;

{constructor TXConductivityParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Units := 'W/m-C or BTU/ft-h-F';
end;}

{ TYConductivityParameter }
function TYConductivityParameter.Units : string;
begin
  result := 'W/m-C or BTU/ft-h-F';
end;

class Function TYConductivityParameter.ANE_ParamName : string ;
begin
  result := kGridYCond;
end;

function TYConductivityParameter.Value : string;
begin
  result := kThermLayer + WriteIndex + '.' + kThermY;
end;

{constructor TYConductivityParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Units := 'W/m-C or BTU/ft-h-F';
end;}

{ TZConductivityParameter }
function TZConductivityParameter.Units : string;
begin
  result := 'W/m-C or BTU/ft-h-F';
end;

class Function TZConductivityParameter.ANE_ParamName : string ;
begin
  result := kGridZCond;
end;

function TZConductivityParameter.Value : string;
begin
  result := kThermLayer + WriteIndex + '.' + kThermZ;
end;

{constructor TZConductivityParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Units := 'W/m-C or BTU/ft-h-F';
end;}

{ TLongDispParameter }
function TLongDispParameter.Units : string;
begin
  result := 'm or ft';
end;

class Function TLongDispParameter.ANE_ParamName : string ;
begin
  result := kGridLongDisp;
end;

function TLongDispParameter.Value : string;
begin
  result := kDispLayer + WriteIndex + '.' + kDispLong;
end;

{constructor TLongDispParameter.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end;}

{ TTransDispParameter }
function TTransDispParameter.Units : string;
begin
  result := 'm or ft';
end;

class Function TTransDispParameter.ANE_ParamName : string ;
begin
  result := kGridTransDisp;
end;

function TTransDispParameter.Value : string;
begin
  result := kDispLayer + WriteIndex + '.' + kDispTrans;
end;

{constructor TTransDispParameter.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end;}

{ TDistCoefParameter }
class Function TDistCoefParameter.ANE_ParamName : string ;
begin
  result := kGridDist;
end;

function TDistCoefParameter.Value : string;
begin
  result := KDistCoef + WriteIndex;
end;

//---------------------------------------

{ TLayerElevationParameter }
constructor TLayerElevationParameter.Create
  (AParameterList : T_ANE_ParameterList; Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
//  Units := 'm or ft';
  ParameterType := gptLayer;
  Lock := Lock + [plDont_Override];
end;

function TLayerElevationParameter.Units : string;
begin
  result := 'm or ft';
end;

class Function TLayerElevationParameter.ANE_ParamName : string ;
begin
  result := kElevation;
end;

function TLayerElevationParameter.Value : string;
begin
  With PIE_Data do
  begin
    result := FloatToStr(HST3DForm.GetZ(StrToInt(WriteIndex)));
  end;
end;

//---------------------------------------

{ TT0Parameter }
constructor TT0Parameter.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
//  Units := 'C or F';
  ParameterType := gptLayer;
  Lock := Lock + [plDont_Override];
end;

function TT0Parameter.Units : string;
begin
  result := 'C or F';
end;

class Function TT0Parameter.ANE_ParamName : string ;
begin
  result := kT0;
end;

function TT0Parameter.Value : string;
begin
  With PIE_Data do
  begin
    result := HST3DForm.adeRefTemp.Text;
  end;
end;

//---------------------------------------
{ TW0Parameter }

constructor TW0Parameter.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ParameterType := gptLayer;
  Lock := Lock + [plDont_Override];
end;

class Function TW0Parameter.ANE_ParamName : string ;
begin
  result := kW0;
end;

function TW0Parameter.Value : string;
begin
  With PIE_Data do
  begin
    result := HST3DForm.adeRefMassFrac.Text;
  end;
end;

//---------------------------------------
{ TObsElevGridParameter }
constructor TObsElevGridParameter.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
//  Units := 'm or ft';
  ParameterType := gptLayer;
  Lock := Lock + [plDont_Override];
end;

function TObsElevGridParameter.Units : string;
begin
  result := 'm or ft';
end;

class Function TObsElevGridParameter.ANE_ParamName : string ;
begin
  result := kObsElevation;
end;

function TObsElevGridParameter.Value : string;
begin
    result := TObsSurfLayer.ANE_LayerName + '.' + TObsElevParam.ANE_ParamName;
end;

//---------------------------------------
{ TGridUnitParameters }

constructor TGridUnitParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kGridActive);
  ParameterOrder.Add(kGridKx);
  ParameterOrder.Add(kGridKy);
  ParameterOrder.Add(kGridKz);
  ParameterOrder.Add(kGridPor);
  ParameterOrder.Add(kGridVertComp);
  ParameterOrder.Add(kGridHeat);
  ParameterOrder.Add(kGridXCond);
  ParameterOrder.Add(kGridYCond);
  ParameterOrder.Add(kGridZCond);
  ParameterOrder.Add(kGridLongDisp);
  ParameterOrder.Add(kGridTransDisp);
  ParameterOrder.Add(kGridDist);
  TActiveCell.Create(self, -1)               ;
  TKxGridParam.Create(self, -1)              ;
  TKyGridParam.Create(self, -1)              ;
  TKzGridParam.Create(self, -1)              ;
  TPorosityParameter.Create(self, -1)        ;
  TVerticalCompParameter.Create(self, -1)    ;
  With PIE_Data do
  begin
    if HST3DForm.cbHeat.Checked then
    begin
      THeatCapacityParameter.Create(self, -1)    ;
      TXConductivityParameter.Create(self, -1)   ;
      TYConductivityParameter.Create(self, -1)   ;
      TZConductivityParameter.Create(self, -1)   ;
    end;
    if HST3DForm.cbHeat.Checked or HST3DForm.cbSolute.Checked then
    begin
      TLongDispParameter.Create(self, -1)        ;
      TTransDispParameter.Create(self, -1)       ;
    end;
    if HST3DForm.cbSolute.Checked then
    begin
      TDistCoefParameter.Create(self, -1)        ;
    end;
  end;
end;

{ TGridNLParameters }
constructor TGridNLParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kElevation);
  TLayerElevationParameter.Create(self, -1)               ;
end;

{ THST3DGridLayer }
constructor THST3DGridLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer);
var
  UnitIndex : integer;
begin
  inherited;// Create(Index, ALayerList);
  DensityLayer:= kDomDens;
  TT0Parameter.Create(ParamList, -1);
  TW0Parameter.Create(ParamList, -1);
  With PIE_Data do
  begin
    for UnitIndex := 1 to HST3DForm.sgGeology.RowCount -1 do
    begin
      TGridUnitParameters.Create(IndexedParamList1, -1);
    end;
    for UnitIndex := 1 to HST3DForm.sgGeology.RowCount do
    begin
      TGridNlParameters.Create(IndexedParamList2, -1);
    end;
  end;

  // make sure the windows handle is allocated before calling assign.
//  PIE_Data.HST3DForm.memoTemplate.Handle;
//  Template.Assign(PIE_Data.HST3DForm.memoTemplate.Lines);
  Template.Assign(PIE_Data.HST3DForm.StrSet1.Strings);
end;

class Function THST3DGridLayer.ANE_LayerName : string ;
begin
  result := kGridLayer;
end;

//----------------------------------
//--------------------------

{ THST3DNodeGridLayer }
constructor THST3DNodeGridLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  DensityLayer:= kDomDens;
  TObsElevGridParameter.Create(ParamList, -1);

end;

class Function THST3DNodeGridLayer.ANE_LayerName : string ;
begin
  result := kGridNodeLayer;
end;


end.
