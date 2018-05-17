unit MFRechConc;

interface

{MFRechConc defines the "Recharge Concentration" layer
 and the associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TRechConcParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TRechargeConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCRechargeConcLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFRechargeConcLayer = 'Recharge Concentration';
  kMFRechargeConcParam = 'Concentration';

class Function TRechConcParam.ANE_ParamName : string ;
begin
  result := kMFRechargeConcParam;
end;

function TRechConcParam.Units : string;
begin
  result := 'M/' + LengthUnit + '^3';
end;

//---------------------------
constructor TRechargeConcTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  NCOMP : integer;
begin
  inherited Create(AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFRechConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);

  ModflowTypes.GetMFRechConcParamType.Create(self, -1);
  if frmModflow.cbMT3D.Checked and frmModflow.cbSSM.Checked then
  begin
    NCOMP := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DConc2ParamClassType.Create(self, -1 );
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DConc3ParamClassType.Create(self, -1 );
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DConc4ParamClassType.Create(self, -1 );
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DConc5ParamClassType.Create(self, -1 );
    end;
  end;
end;

//---------------------------
constructor TMOCRechargeConcLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMOCRechargeConcTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TMOCRechargeConcLayer.ANE_LayerName : string ;
begin
  result := kMFRechargeConcLayer;
end;

end.
