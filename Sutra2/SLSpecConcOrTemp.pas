unit SLSpecConcOrTemp;

interface

uses ANE_LayerUnit, AnePIE;

type
  TSpecConcTempParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    class function WriteParamName : string; override;
  end;

  TSpecConcTempLayer = class(T_ANE_InfoLayer)
//    OldName : String;
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
//    function WriteLayer(const CurrentModelHandle : ANE_PTR) : string; override;
    class function WriteNewRoot : string; override;
//    function WriteOldLayerName : string; override;
  end;

implementation

uses SLGeneralParameters, frmSutraUnit;

ResourceString
  kSpecConcTempParam = 'specified_conc_or_temp';
  kSpecConcTempLayer = 'Specified Conc or Temp';

{ TSpecConcTempParam }

class function TSpecConcTempParam.ANE_ParamName: string;
begin
  result := kSpecConcTempParam;
end;

function TSpecConcTempParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or degC'
      end;
    ttEnergy:
      begin
        result := 'degC';
      end;
    ttSolute:
      begin
        result := 'C';
      end;
    else
      begin
        Assert(False);
      end;
  end;
end;

function TSpecConcTempParam.Value: string;
begin
  result := kNa;
end;

function TSpecConcTempParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TSpecConcTempParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSpecConcTempParam.ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'specified_temperature';
      end;
    ttSolute:
      begin
        result := 'specified_concentration';
      end;
    else
      begin
        Assert(False);
      end;
  end;
end;

{ TSpecConcTempLayer }

class function TSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kSpecConcTempLayer;
end;

constructor TSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  RenameAllParameters := True;
  TSpecConcTempParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
end;

{function TSpecConcTempLayer.WriteLayer(
  const CurrentModelHandle: ANE_PTR): string;
begin
  OldName := WriteNewLayerName;
  result := inherited WriteLayer(CurrentModelHandle);
end;  }

class function TSpecConcTempLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSpecConcTempLayer.ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Specified Temperature';
      end;
    ttSolute:
      begin
        result := 'Specified Concentration';
      end;
    else
      begin
        Assert(False);
      end;
  end;

{  if frmSutra.rbGeneral.Checked then
  begin
    result := TSpecConcTempLayer.ANE_LayerName;
  end
  else if frmSutra.rbEnergy.Checked then
  begin
    result := 'Specified Temperature';
  end
  else
  begin
    result := 'Specified Concentration';
  end; }
end;

{function TSpecConcTempLayer.WriteOldLayerName: string;
begin
  result := OldName;
end;  }

end.
 