unit MonthlyDataImportUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, AnePIE, CheckLst;

type THST3DInfoLayerType = (ltError, ltActiveArea, ltAqInfl,
       ltAqLeak, ltDisp, ltDistCoef,
       ltDensity, ltET, ltHeatCap, ltHeatCond,
       ltInitMassFrac, ltInitPres, ltInitTemp, ltInitWatTab, ltPerm, ltPoros,
       ltRiv, ltHorSpecFlux, ltVerSpecFlux, ltSpecState, ltThermCond,
       ltVertComp, ltWell);

type
  TfrmImport = class(TForm)
    ScrollBox1: TScrollBox;
    rgItems: TRadioGroup;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    dlgOpenImport: TOpenDialog;
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    clbReset: TCheckListBox;
    procedure btnOKClick(Sender: TObject);
    procedure rgItemsClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    CurrentLayerType : THST3DInfoLayerType;
    { Public declarations }
  end;


var
  frmImport: TfrmImport;

function readParameters(LayerHandle : ANE_PTR) : boolean;

function IdentifyHST3DInfoLayerType (LayerHandle : ANE_PTR): Integer;

implementation

uses ShellAPI, ANE_LayerUnit, ANECB, HST3DActiveAreaLayers,
     HST3DAquifInflLayers,
     HST3DAquifLeakageLayers, HST3DDispersivityLayers, HST3DDistCoefLayers,
     HST3DDomainDensityLayers, HST3DEvapotranspirationLayers,
     HST3DHeatCapacityLayers, HST3DHeatCondLayers, HST3DInitialMassFracLayers,
     HST3DInitialPressureLayers, HST3DInitialTemp, HST3DInitialWatTabLayers,
     HST3DPermeabilityLayers, HST3DPorosityLayers, HST3DRiverLayers,
     HST3DSpecifiedFluxLayers, HST3DSpecifiedStateLayers, HST3DThermCondLayers,
     HST3DVertCompLayers, HST3DWellLayers, HST3DGeneralParameters,
     HST3D_PIE_Unit, ShowHelpUnit;

{$R *.DFM}

function ParamInLayer(LayerHandle : ANE_PTR; paramName : string) : boolean;
var
  AnInteger : integer;
begin
    AnInteger := ANE_LayerGetParameterByName(PIE_Data.HST3DForm.CurrentModelHandle,
         layerHandle, PChar(paramName) );
  if AnInteger > -1
  then
    begin
      result := True;
    end
  else
    begin
      result := False
    end;
end;

function FirstParamInLayer(LayerHandle : ANE_PTR; ParamNames : TStringList)
  : integer;
var
  index : integer;
begin
  result := -1;
  for index := 0 to ParamNames.Count -1 do
  begin
    if ParamInLayer(LayerHandle, ParamNames.Strings[index])
    then
      begin
        result := index;
        break;
      end;
  end;
end;


function IdentifyHST3DInfoLayerType (LayerHandle : ANE_PTR): Integer;
var
  NamesList : TStringList;
begin
  NamesList := TStringList.Create;
  try
    begin
      NamesList.Add(kActiveAreaUnit + '1');       // Active Area
      NamesList.Add(kAqInflWeight);               // Aquifer influence
      NamesList.Add(KAqLeakPotE + '1');           // Aquifer leakage (sometimes)
      NamesList.Add(kDispLong);                   // dispersivity
      NamesList.Add(KDistCoef + '1');             // distribtion coefficient
      NamesList.Add(kDomDens);                    // Density layer
      NamesList.Add(kETMax + '1');                // ET
      NamesList.Add(kHeatCap + '1');              // heat capacity
      NamesList.Add(kInitMassFrac);               // initial mass fraction
      NamesList.Add(kInitScMassFrac);             // initial mass fraction
      NamesList.Add(kInitPres + '1');             // initial pressure
      NamesList.Add(kInitTemp + '1');             // initial temperature
      NamesList.Add(kInitWat);                    // initial water table
      NamesList.Add(kPermKx);                     // permeability
      NamesList.Add(kPorosityUnit + '1');         // porosity
      NamesList.Add(kRivPerm);                    // river
      NamesList.Add(kSpecFluxUpFluid + '1');      // hor specified flux
      NamesList.Add(kSpecFluxFluid + '1');        // ver specified flux
      NamesList.Add(kSpecStateSpePres + '1');     // specified state
      NamesList.Add(kSpecStateTemp + '1');        // specified state
      NamesList.Add(kSpecStateMassFrac + '1');    // specified state
      NamesList.Add(kSpecStateScMassFrac + '1');  // specified state
      NamesList.Add(kThermX);                     // thermal conductivity
      NamesList.Add(kVertComp + '1');             // vertical compressibility
      NamesList.Add(KWellFlow + '1');             // well
      NamesList.Add(kGenParDens + '1');           // Aquifer leakage
      NamesList.Add(kHeatCondDiff);               // heat conduction
      result := FirstParamInLayer(LayerHandle, NamesList);
    end;
  finally
    begin
      NamesList.Free
    end;
  end;
end;

function HST3DInfoLayerType (LayerHandle : ANE_PTR): THST3DInfoLayerType;
begin
  case IdentifyHST3DInfoLayerType (LayerHandle) of
    -1: result  :=  ltError          ;     // error
     0: result  :=  ltActiveArea     ;     // Active Area
     1: result  :=  ltAqInfl         ;     // Aquifer influence
     2: result  :=  ltAqLeak         ;     // Aquifer leakage (sometimes)
     3: result  :=  ltDisp           ;
     4: result  :=  ltDistCoef       ;     // dispersivity
     5: result  :=  ltDensity        ;     // distribtion coefficient
     6: result  :=  ltET             ;     // Density layer
     7: result  :=  ltHeatCap        ;     // ET
     8: result  :=  ltInitMassFrac   ;     // heat conduction
     9: result :=  ltInitMassFrac  ;     // initial mass fraction
     10 :result :=  ltInitPres      ;     // initial mass fraction
     11 :result :=  ltInitTemp      ;     // initial pressure
     12 :result :=  ltInitWatTab    ;     // initial temperature
     13: result :=  ltPerm          ;     // initial water table
     14: result :=  ltPoros         ;     // permeability
     15: result :=  ltRiv           ;     // porosity
     16: result :=  ltHorSpecFlux   ;     // river
     17: result :=  ltVerSpecFlux   ;     // hor specified flux
     18: result :=  ltSpecState     ;     // ver specified flux
     19: result :=  ltSpecState     ;     // specified state
     20: result :=  ltSpecState     ;     // specified state
     21: result :=  ltSpecState     ;     // specified state
     22: result :=  ltThermCond     ;     // specified state
     23: result :=  ltVertComp      ;     // thermal conductivity
     24: result :=  ltWell          ;     // vertical compressibility
     25: result :=  ltAqLeak         ;     // Aquifer leakage
     26: result :=  ltHeatCond       ;     // heat capacity
     else result := ltError          ;     // error
  end;
end;

function readParameters(LayerHandle : ANE_PTR) : boolean;
var
  AnIndexedLayerList : T_ANE_IndexedLayerList ;
  AHorAqInflLayer : THorAqInflLayer;
  ParameterNames : TStringList ;
  AnAqInflTimeParameters : TAqInflTimeParameters;
  AHorAqLeakageLayer : THorAqLeakageLayer;
  AnAqLeakTimeParameters : TAqLeakTimeParameters;
  AHorETLayer : THorETLayer;
  AnETTimeParameters : TETTimeParameters;
  ARiverLayer : TRiverLayer;
  ARiverTimeParameters : TRiverTimeParameters;
  AHorSpecFluxLayer : THorSpecFluxLayer;
  AHorSpecFluxTimeParameters : THorSpecFluxTimeParameters;
  AVerSpecFluxLayer : TVerSpecFluxLayer;
  AVerSpecFluxTimeParameters : TVerSpecFluxTimeParameters;
  ASpecifiedStateLayer : TSpecifiedStateLayer;
  ASpecifiedStateTimeParameters : TSpecifiedStateTimeParameters;
  AWellLayer : TWellLayer;
  AWellTimeParameters : TWellTimeParameters;
  index : integer;

begin
  frmImport.CurrentLayerType := HST3DInfoLayerType(LayerHandle);
  result := false;
  ParameterNames := TStringList.Create ;
  try
    begin
      With PIE_Data.HST3DForm.LayerStructure do
      begin
        AnIndexedLayerList := ListsOfIndexedLayers.Items[0];
        case frmImport.CurrentLayerType of
           ltError, ltActiveArea, ltDisp, ltDistCoef, ltDensity, ltHeatCap,
           ltHeatCond, ltInitMassFrac, ltInitPres,  ltInitTemp, ltInitWatTab,
           ltPerm, ltPoros, ltThermCond, ltVertComp:
             begin
               ShowMessage('You can not import temporal data for this layer');
               result := false;
             end;
           ltAqInfl:
             begin
               AHorAqInflLayer :=
                 AnIndexedLayerList.GetLayerByName(kAqInflHorLayer)
                 as THorAqInflLayer;
               AnAqInflTimeParameters
                 := AHorAqInflLayer.IndexedParamList2.Items[0]
                 as TAqInflTimeParameters;
               ParameterNames.Assign(AnAqInflTimeParameters.ParameterOrder);
               result := true;
             end;
           ltAqLeak:
             begin
               AHorAqLeakageLayer :=
                 AnIndexedLayerList.GetLayerByName(KAqLeakHorLay)
                 as THorAqLeakageLayer;
               AnAqLeakTimeParameters
                 := AHorAqLeakageLayer.IndexedParamList2.Items[0]
                 as TAqLeakTimeParameters;
               ParameterNames.Assign(AnAqLeakTimeParameters.ParameterOrder);
               result := true;
             end;
           ltET:
             begin
               AHorETLayer :=
                 UnIndexedLayers.GetLayerByName(kETHorLay) as THorETLayer;
               AnETTimeParameters := AHorETLayer.IndexedParamList2.Items[0]
                 as TETTimeParameters;
               ParameterNames.Assign(AnETTimeParameters.ParameterOrder);
               result := true;
             end;
           ltRiv:
             begin
               ARiverLayer :=
                 UnIndexedLayers.GetLayerByName(kRivLayer) as TRiverLayer;
               ARiverTimeParameters := ARiverLayer.IndexedParamList2.Items[0]
                 as TRiverTimeParameters;
               ParameterNames.Assign(ARiverTimeParameters.ParameterOrder);
               result := true;
             end;
           ltHorSpecFlux:
             begin
               AHorSpecFluxLayer :=
                 AnIndexedLayerList.GetLayerByName(kSpecFluxHorLay)
                 as THorSpecFluxLayer;
               AHorSpecFluxTimeParameters
                 := AHorSpecFluxLayer.IndexedParamList2.Items[0]
                 as THorSpecFluxTimeParameters;
               ParameterNames.Assign(AHorSpecFluxTimeParameters.ParameterOrder);
               result := true;
             end;
           ltVerSpecFlux:
             begin
               AVerSpecFluxLayer :=
                 AnIndexedLayerList.GetLayerByName(kSpecFluxHorLay)
                 as TVerSpecFluxLayer;
               AVerSpecFluxTimeParameters
                 := AVerSpecFluxLayer.IndexedParamList2.Items[0]
                 as TVerSpecFluxTimeParameters;
               ParameterNames.Assign
                 (AVerSpecFluxTimeParameters.ParameterOrder);
               result := true;
             end;
           ltSpecState:
             begin
               ASpecifiedStateLayer :=
                 AnIndexedLayerList.GetLayerByName(kSpecStateLayer)
                 as TSpecifiedStateLayer;
               ASpecifiedStateTimeParameters
                 := ASpecifiedStateLayer.IndexedParamList2.Items[0]
                 as TSpecifiedStateTimeParameters;
               ParameterNames.Assign
                 (ASpecifiedStateTimeParameters.ParameterOrder);
               result := true;
             end;
           ltWell:
             begin
               AWellLayer :=
                 UnIndexedLayers.GetLayerByName(kWellLayerName) as TWellLayer;
               AWellTimeParameters := AWellLayer.IndexedParamList2.Items[0]
                 as TWellTimeParameters;
               ParameterNames.Assign(AWellTimeParameters.ParameterOrder);
               result := true;
             end;
        end; // case CurrentLayer of
      end; // With PIE_Data.HST3DForm.LayerStructure do
      if ParameterNames.Count > 0 then
      begin
        for index := 0 to ParameterNames.Count -1 do
        begin
          if not (ParameterNames.Strings[index] = kGenParTime) and
              ParamInLayer(layerhandle, ParameterNames.Strings[index] + '1')
              then
          begin
            frmImport.rgItems.Items.Add(ParameterNames.Strings[index]);
            frmImport.clbReset.Items.Add(ParameterNames.Strings[index]);
//            frmImport.RzclReset.Items.Add(ParameterNames.Strings[index]);
          end;
        end;
      end;
    end
  finally
    begin
      frmImport.rgItems.Height := frmImport.rgItems.Items.Count * 23 + 15;
      ParameterNames.Free;
    end;
  end;
end;

procedure TfrmImport.btnOKClick(Sender: TObject);
begin
  if dlgOpenImport.Execute
  then
    begin
      ModalResult := mrOK;
    end
  else
    begin
      ModalResult := mrNone;
    end;
end;

procedure TfrmImport.rgItemsClick(Sender: TObject);
var
  index : integer;
begin
  For index := 0 to rgItems.Items.Count -1 do
  begin
    if (rgItems.ItemIndex = index)
    then
      begin
//        RzclReset.ItemEnabled[index] := False;
        clbReset.ItemEnabled[index] := False;
//        RzclReset.ItemState[index] := cbUnchecked;
        clbReset.State[index] := cbUnchecked;
      end
    else
      begin
        clbReset.ItemEnabled[index] := True;
//        RzclReset.ItemEnabled[index] := True;
      end;
  end;
end;

procedure TfrmImport.BitBtn1Click(Sender: TObject);
begin
  ShowSpecificHTMLHelp('import.htm');
end;

end.

