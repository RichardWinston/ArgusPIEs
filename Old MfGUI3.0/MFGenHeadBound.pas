unit MFGenHeadBound;

interface

{MFGenHeadBound defines the "Point GHB Unit[i]", "Line GHB Unit[i]"
 and "Area GHB Unit[i]" layers
 and associated parameters and Parameterlists.}

uses ANE_LayerUnit, SysUtils;

type
  TGHBHeadParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TGHBTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TPointGHBLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TLineGHBLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaGHBLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFPointGHB = 'Point Gen Head Bound Unit';
  kMFLineGHB = 'Line Gen Head Bound Unit';
  kMFAreaGHB = 'Area Gen Head Bound Unit';
  kMFGHBHead = 'Head Stress';

class Function TGHBHeadParam.ANE_ParamName : string ;
begin
  result := kMFGHBHead;
end;

function TGHBHeadParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
constructor TGHBTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create(AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFGHBHeadParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFGHBHeadParamType.Create( self, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFConcentrationParamType.Create( self, -1);
  end;
  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
end;

//---------------------------
constructor TPointGHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFConductanceParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetGHBTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TPointGHBLayer.ANE_LayerName : string ;
begin
  result := kMFPointGHB;
end;

//---------------------------
constructor TLineGHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);

  ModflowTypes.GetMFConductanceParamType.Create(ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetGHBTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TLineGHBLayer.ANE_LayerName : string ;
begin
  result := kMFLineGHB;
end;

//---------------------------
constructor TAreaGHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

  ModflowTypes.GetMFConductanceParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetGHBTimeParamListType.Create( IndexedParamList2, -1);
  end;
end;

class Function TAreaGHBLayer.ANE_LayerName : string ;
begin
  result := kMFAreaGHB;
end;

end.

