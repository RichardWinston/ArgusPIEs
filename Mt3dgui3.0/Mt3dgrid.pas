unit MT3DGrid;

interface

uses ANE_LayerUnit, MFGrid, SysUtils;

const
  kMT3DPorosity = 'MT3D Porosity Unit';
  kMT3DICBUND = 'ICBUND Unit';
  kMFActiveCell = 'Active Cell Unit';
  kMT3DActiveCell = 'Active MT3D Cell Unit';
  kMT3DInitConcCell = 'MT3D Initial Concentration Unit';
  kMT3DTimeVaryConcCell = 'MT3D Time Variant Concentration Location Unit';
  kMT3DObsLocCell = 'MT3D Observation Location Unit';
  kMT3DLongDispCell = 'MT3D Longitudinal Dispersivity Unit';
  kMFLakeParam = 'LakeParam Unit';
  kMFLakeToRightParam = 'Lake To Right Unit';
  kMFLakeToLeftParam = 'Lake To Left Unit';
  kMFLakeToNorthParam = 'Lake To North Unit';
  kMFLakeToSouthParam = 'Lake To South Unit';
  kMFLakeAboveParam = 'Lake Above Unit';
  kMFLakebedBottomParam = 'Lakebed Bottom Unit';
  kMFLakebedTopParam = 'Lakebed Top Unit';
  kMFLakebedKzParam = 'Lakebed Kz Unit';
  kMFSeepageParam = 'Seepage Location Unit';

type
  TMT3DIBoundGridParam = class(TIBoundGridParam)
    function Value : string; override;
  end;


  TGridMT3DPorosity = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridMT3DICBUND = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridMFActiveCell = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridMT3DActiveCell = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridMT3DInitConcCell = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridMT3DTimeVaryConcCell = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridMT3DObsLocCell = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridMT3DLongDispCell = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

// Lake grid parameters
  TGridLakeParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridLakeToRightParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridLakeToLeftParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridLakeToNorthParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridLakeToSouthParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridLakeAboveParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridLakebedBottomParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridLakebedTopParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridLakebedKzParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    Constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridSeepage = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;



// list of grid parameters
  TMT3DGeologicUnitParameters = class(TGeologicUnitParameters)
    constructor Create
     (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

implementation

uses MT3DPorosityUnit, Variables, MFWells, MFGenParam, MT3DTimeVaryConc,
     MT3DGeneralParameters, MFDomainOut, MT3DDomainOutline,
     MT3DInactiveLayer, MT3DConstantConcentration, MT3DFormUnit, MT3DInitConc,
     MT3DHydraulicCond, MFRBWLake;


//--------------------------------------------------
class Function TGridMT3DPorosity.ANE_ParamName : string ;
begin
  result := kMT3DPorosity;
end;

function TGridMT3DPorosity.Value : string;
begin
  result := TMT3DPorosityLayer.ANE_LayerName + WriteIndex;
end;

function TGridMT3DPorosity.Units : string;
begin
  result := 'L^3/L^3';
end;

//--------------------------------------------------
class Function TGridMT3DICBUND.ANE_ParamName : string ;
begin
  result := kMT3DICBUND;
end;

Constructor TGridMT3DICBUND.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridMT3DICBUND.Value : string;
begin
  result := 'If((CountObjectsInBlock('
    + ModflowTypes.GetMT3DPointConstantConcLayerType.ANE_LayerName + WriteIndex
    + ',0)>0)|'
    + ModflowTypes.GetMT3DAreaConstantConcLayerType.ANE_LayerName + WriteIndex
    + '!=$N/A,-1, 1)*'
    + ModflowTypes.GetGridMFActiveCellParamClassType.ANE_ParamName + WriteIndex;
end;

function TGridMT3DICBUND.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridMFActiveCell.ANE_ParamName : string ;
begin
  result := kMFActiveCell;
end;

Constructor TGridMFActiveCell.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridMFActiveCell.Value : string;
var
  FirstParameter : boolean;
begin
  FirstParameter := True;
  result := 'If((';
  if frmMODFLOW.cbWEL.Checked  or frmMODFLOW.cbRIV.Checked or
     frmMODFLOW.cbDRN.Checked  or frmMODFLOW.cbGHB.Checked or
     frmMODFLOW.cbMT3D.Checked then
  begin
    result := result + '(';
  end;
  if frmMODFLOW.cbWEL.Checked then
  begin
    result := result + 'CountObjectsInBlock(' + ModflowTypes.GetMFWellLayerType.ANE_LayerName +
      WriteIndex + '.' + TWellStressParam.ANE_ParamName + '1,0)>0';
    FirstParameter := False;
  end;
  if frmMODFLOW.cbRIV.Checked then
  begin
    if not FirstParameter then
    begin
      result := result + '|';
    end;
    result := result + 'CountObjectsInBlock(' + ModflowTypes.GetMFPointRiverLayerType.ANE_LayerName +
      WriteIndex + '.' + TConductance.ANE_ParamName + ',0,1)>0'
      + '|CountObjectsInBlock(' + ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName +
      WriteIndex + '.' + TConductance.ANE_ParamName + ',0,1)>0';
    FirstParameter := False;
  end;
  if frmMODFLOW.cbDRN.Checked then
  begin
    if not FirstParameter then
    begin
      result := result + '|';
    end;
    result := result + 'CountObjectsInBlock(' + ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName +
      WriteIndex + '.' + TConductance.ANE_ParamName + ',0,1)>0|'
      + 'CountObjectsInBlock(' + ModflowTypes.GetLineDrainLayerType.ANE_LayerName +
      WriteIndex + '.' + TConductance.ANE_ParamName + ',0,1)>0';
    FirstParameter := False;
  end;
  if frmMODFLOW.cbGHB.Checked then
  begin
    if not FirstParameter then
    begin
      result := result + '|';
    end;
    result := result + 'CountObjectsInBlock(' + ModflowTypes.GetPointGHBLayerType.ANE_LayerName +
      WriteIndex + '.' + TConductance.ANE_ParamName + ',0)>0' + '|CountObjectsInBlock('
      + ModflowTypes.GetLineGHBLayerType.ANE_LayerName +
      WriteIndex + '.' + TConductance.ANE_ParamName + ',1)>0';
    FirstParameter := False;
  end;
  if frmMODFLOW.cbMT3D.Checked then
  begin
    if not FirstParameter then
    begin
      result := result + '|';
    end;
    result := result + 'CountObjectsInBlock('
      + ModflowTypes.GetMT3DPointConstantConcLayerType.ANE_LayerName + WriteIndex
      + ',0)>0|';
      if frmMODFLOW.cbMT3D_TVC.Checked then
      begin
        result := result
          + 'CountObjectsInBlock('
          + ModflowTypes.GetMT3DPointTimeVaryConcLayerType.ANE_LayerName + WriteIndex + '.'
          + ModflowTypes.GetMT3DTopElevParamClassType.ANE_ParamName + ',0)>0|'
      end;
      result := result
      + 'CountObjectsInBlock('
      + ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName + WriteIndex + '.'
      + ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName + ',0)>0|CountObjectsInBlock('
      + ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName + WriteIndex
      + ',0,1)>0';
    FirstParameter := False;
  end;
  if frmMODFLOW.cbWEL.Checked  or frmMODFLOW.cbRIV.Checked or
     frmMODFLOW.cbDRN.Checked  or frmMODFLOW.cbGHB.Checked or
     frmMODFLOW.cbMT3D.Checked then
  begin
    result := result + ')&';
  end;
  result := result + '(CountObjectsInBlock(' + ModflowTypes.GetMFDomainOutType.ANE_LayerName
    + '.' + TDomDensityParam.ANE_ParamName + ')))|(BlockIsActive()), 1, 0)'

end;

function TGridMFActiveCell.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridMT3DActiveCell.ANE_ParamName : string ;
begin
  result := kMT3DActiveCell;
end;

Constructor TGridMT3DActiveCell.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridMT3DActiveCell.Value : string;
begin
  result := 'If('
    + TIBoundGridParam.ANE_ParamName + WriteIndex
    + '=0, 0, If(('
    + TMT3DDomOutlineLayer.ANE_LayerName
    + '!=' + kNA + '&' +
    TMT3DInactiveAreaLayer.ANE_LayerName + WriteIndex
    + '!=0)|(CountObjectsInBlock('
    + TMT3DDomOutlineLayer.ANE_LayerName
    + ')>0&(CountObjectsInBlock('
    + TMT3DAreaConstantConcLayer.ANE_LayerName + WriteIndex
    + ',0,1)>0&'
    + TMT3DInactiveAreaLayer.ANE_LayerName + WriteIndex
    + '!=0)), 1, 0))'

end;

function TGridMT3DActiveCell.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridMT3DInitConcCell.ANE_ParamName : string ;
begin
  result := kMT3DInitConcCell;
end;

function TGridMT3DInitConcCell.Value : string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMT3DPointConstantConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName
    + ',0)>0, '
    + ModflowTypes.GetMT3DPointConstantConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName
    + '/(('
    + ModflowTypes.GetMFTopElevLayerType.ANE_LayerName + WriteIndex
    + '-'
    + ModflowTypes.GetBottomElevLayerType.ANE_LayerName + WriteIndex
    + ')*BlockArea()/'
    + 'MODFLOW_NDIV'
    + '('
    + WriteIndex + ')), If('
    + ModflowTypes.GetMT3DAreaConstantConcLayerType.ANE_LayerName + WriteIndex
    + '!=$N/A, '
    + ModflowTypes.GetMT3DAreaConstantConcLayerType.ANE_LayerName + WriteIndex
    + ', If(CountObjectsInBlock('
    + ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName
    + ',0)>0, '
    + ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName
    + '/(('
    + ModflowTypes.GetMFTopElevLayerType.ANE_LayerName + WriteIndex
    + '-'
    + ModflowTypes.GetBottomElevLayerType.ANE_LayerName + WriteIndex
    + ')*BlockArea()/'
    + 'MODFLOW_NDIV'
    + '(' + WriteIndex + ')), If(('
    + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
    + '<0)&('
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex 
    + '.'
    + ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName + WriteIndex
    + '!=$N/A), '
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName + WriteIndex
    + ','
    + ModflowTypes.GetMT3DAreaInitConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DInitConcParamClassType.ANE_ParamName 
    + '))))';

end;

function TGridMT3DInitConcCell.Units : string;
begin
  result := 'M/L^3';
end;

//--------------------------------------------------
class Function TGridMT3DTimeVaryConcCell.ANE_ParamName : string ;
begin
  result := kMT3DTimeVaryConcCell;
end;

function TGridMT3DTimeVaryConcCell.Value : string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMT3DPointTimeVaryConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DTopElevParamClassType.ANE_ParamName
    + ',0)>0|CountObjectsInBlock('
    + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName
    + '1,2)>0|'
    + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName
    + '1!=$N/A, 1, 0)';

end;

function TGridMT3DTimeVaryConcCell.Units : string;
begin
  result := 'M/L^3';
end;

//--------------------------------------------------
class Function TGridMT3DObsLocCell.ANE_ParamName : string ;
begin
  result := kMT3DObsLocCell;
end;

function TGridMT3DObsLocCell.Value : string;
begin
  result := 'If(CountObjectsInBlock('
  + ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName + WriteIndex
  + ',0)>0|CountObjectsInBlock('
  + ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName + WriteIndex
  + ',1)>0|'
  + ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName + WriteIndex
  + '!=$N/A, 1, 0)';

end;

function TGridMT3DObsLocCell.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridMT3DLongDispCell.ANE_ParamName : string ;
begin
  result := kMT3DLongDispCell;
end;

function TGridMT3DLongDispCell.Value : string;
begin
  result := ModflowTypes.GetHydraulicCondLayerType.ANE_LayerName + WriteIndex
      + '.' + ModflowTypes.GetMT3DLongDispParamClassType.ANE_ParamName;
end;

function TGridMT3DLongDispCell.Units : string;
begin
  result := 'L';
end;

//--------------------------------------------------
class Function TGridLakeParam.ANE_ParamName : string ;
begin
  result := kMFLakeParam;
end;

function TGridLakeParam.Value : string;
var
  Index : integer;
  NextIndex : string;
begin
  Index := StrToInt(WriteIndex);
  if Index = StrToInt(frmMODFLOW.edNumUnits.Text)
  then
    begin
      result := 'If(' + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + WriteIndex + '.' +
        TLakeNumberParam.ANE_ParamName + ', ' + ModflowTypes.GetMFLakeLayerType.ANE_LayerName +
        WriteIndex + '.' +TLakeNumberParam.ANE_ParamName + ', 0)';
    end
  else
    begin
      NextIndex := IntToStr(Index +1);
      result := 'If(' + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + NextIndex + ', '
        + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + NextIndex + ', ' +
        'If(' + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + WriteIndex + '.' +
          TLakeNumberParam.ANE_ParamName + ', ' + ModflowTypes.GetMFLakeLayerType.ANE_LayerName +
          WriteIndex + '.' +TLakeNumberParam.ANE_ParamName + ', 0))'
    end;
end;

function TGridLakeParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridLakeToRightParam.ANE_ParamName : string ;
begin
  result := kMFLakeToRightParam;
end;

Constructor TGridLakeToRightParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridLakeToRightParam.Value : string;
begin
      result := 'If(CalcAtBlock(Column()+1, Row(), ' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex + ')&!'
      + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      + ', CalcAtBlock(Column()+1, Row(), '
      + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      + '), 0)';
end;

function TGridLakeToRightParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridLakeToLeftParam.ANE_ParamName : string ;
begin
  result := kMFLakeToLeftParam;
end;

Constructor TGridLakeToLeftParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridLakeToLeftParam.Value : string;
begin
      result := 'If(CalcAtBlock(Column()-1, Row(), ' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex + ')&!'
      + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      + ', CalcAtBlock(Column()-1, Row(), '
      + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      + '), 0)';
end;

function TGridLakeToLeftParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridLakeToNorthParam.ANE_ParamName : string ;
begin
  result := kMFLakeToNorthParam;
end;

Constructor TGridLakeToNorthParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridLakeToNorthParam.Value : string;
begin
      result := 'If(CalcAtBlock(Column(), Row()+1, ' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex + ')&!'
      + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      + ', CalcAtBlock(Column(), Row()+1, '
      + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      + '), 0)';
end;

function TGridLakeToNorthParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridLakeToSouthParam.ANE_ParamName : string ;
begin
  result := kMFLakeToSouthParam;
end;

Constructor TGridLakeToSouthParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridLakeToSouthParam.Value : string;
begin
      result := 'If(CalcAtBlock(Column(), Row()-1, ' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex + ')&!'
      + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      + ', CalcAtBlock(Column(), Row()-1, '
      + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      + '), 0)';
end;

function TGridLakeToSouthParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridLakeAboveParam.ANE_ParamName : string ;
begin
  result := kMFLakeAboveParam;
end;

Constructor TGridLakeAboveParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridLakeAboveParam.Value : string;
var
  Index : integer;
  PreviousIndex : string;
begin
  Index := StrToInt(WriteIndex);
  if Index = 1
  then
    begin
      result := '0'
    end
  else
    begin
      PreviousIndex := IntToStr(Index-1);
      result := 'If(' + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + PreviousIndex + ', '
         + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + PreviousIndex + ', 0)'
    end;

end;

function TGridLakeAboveParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridLakebedBottomParam.ANE_ParamName : string ;
begin
  result := kMFLakebedBottomParam;
end;

Constructor TGridLakebedBottomParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridLakebedBottomParam.Value : string;
var
  Index : integer;
  NextIndex : string;
begin
  Index := StrToInt(WriteIndex);
  if Index = StrToInt(frmMODFLOW.edNumUnits.Text)
  then
    begin
      result := 'If(' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      +', '
      + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + WriteIndex + '.' + TLakeBottomElevParam.ANE_ParamName
      + ', $N/A)';
    end
  else
    begin
      NextIndex := IntToStr(Index +1);
      result := 'If(' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      +', '
      + 'If(IsNumber('
      + ModflowTypes.GetGridMT3DLakebedBottomParamClassType.ANE_ParamName + NextIndex
      + '), '
      + ModflowTypes.GetGridMT3DLakebedBottomParamClassType.ANE_ParamName + NextIndex
      + ', '
      + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + WriteIndex + '.'
      + TLakeBottomElevParam.ANE_ParamName
      + '), $N/A)';
    end;
end;

function TGridLakebedBottomParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridLakebedTopParam.ANE_ParamName : string ;
begin
  result := kMFLakebedTopParam;
end;

Constructor TGridLakebedTopParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridLakebedTopParam.Value : string;
var
  Index : integer;
  NextIndex : string;
begin
  Index := StrToInt(WriteIndex);
  if Index = StrToInt(frmMODFLOW.edNumUnits.Text)
  then
    begin
      result := 'If(' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      +', '
      + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + WriteIndex + '.' + TLakeTopElevParam.ANE_ParamName
      + ', $N/A)';
    end
  else
    begin
      NextIndex := IntToStr(Index +1);
      result := 'If(' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      +', '
      + 'If(IsNumber('
      + ModflowTypes.GetGridMT3DLakebedTopParamClassType.ANE_ParamName + NextIndex
      + '), '
      + ModflowTypes.GetGridMT3DLakebedTopParamClassType.ANE_ParamName + NextIndex
      + ', '
      + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + WriteIndex + '.'
      + TLakeTopElevParam.ANE_ParamName
      + '), $N/A)';
    end;
end;

function TGridLakebedTopParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------
class Function TGridLakebedKzParam.ANE_ParamName : string ;
begin
  result := kMFLakebedKzParam;
end;

Constructor TGridLakebedKzParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridLakebedKzParam.Value : string;
var
  Index : integer;
  NextIndex : string;
begin
  Index := StrToInt(WriteIndex);
  if Index = StrToInt(frmMODFLOW.edNumUnits.Text)
  then
    begin
      result := 'If(' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      +', '
      + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + WriteIndex + '.' + TLakeHydCond.ANE_ParamName
      + ', $N/A)';
    end
  else
    begin
      NextIndex := IntToStr(Index +1);
      result := 'If(' +
      ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
      +', '
      + 'If(IsNumber('
      + ModflowTypes.GetGridMT3DLakebedKzParamClassType.ANE_ParamName + NextIndex
      + '), '
      + ModflowTypes.GetGridMT3DLakebedKzParamClassType.ANE_ParamName + NextIndex
      + ', '
      + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + WriteIndex + '.'
      + TLakeHydCond.ANE_ParamName
      + '), $N/A)';
    end;
end;

function TGridLakebedKzParam.Units : string;
begin
  result := '';
end;

//--------------------------------------------------

constructor TMT3DGeologicUnitParameters.Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakeToRightParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakeToLeftParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakeToNorthParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakeToSouthParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakeAboveParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakebedTopParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakebedBottomParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLakebedKzParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridSeepageParamClassType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetGridMT3DPorosityParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DICBUNDParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMFActiveCellParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DActiveCellParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DInitConcCellParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DObsLocCellParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLongDispCellParamClassType.ANE_ParamName);
  if frmMODFLOW.cbLAK.Checked then
  begin
    ModflowTypes.GetGridMT3DLakeParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLakeToRightParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLakeToLeftParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLakeToNorthParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLakeToSouthParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLakeAboveParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLakebedTopParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLakebedBottomParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLakebedKzParamClassType.Create(self, -1);
  end;
  if frmMODFLOW.cbspg.Checked then
  begin
    ModflowTypes.GetGridSeepageParamClassType.Create(self, -1);
  end;
  if frmMODFLOW.cbMT3D.Checked then
  begin
    ModflowTypes.GetGridMT3DPorosityParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DICBUNDParamClassType.Create(self, -1);
    ModflowTypes.GetGridMFActiveCellParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DActiveCellParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DInitConcCellParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DObsLocCellParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLongDispCellParamClassType.Create(self, -1);

    if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked
      and frmMODFLOW.cbMT3D_TVC.Checked then
    begin
      ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType.Create(self, -1);
    end;
  end;

end;

{ TMT3DIBoundGridParam }

function TMT3DIBoundGridParam.Value: string;
begin
  result := inherited Value;
  if frmMODFLOW.cbLAK.Checked then
  begin
    result := result  + '*('
    + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
    + '=0)'
  end
{  result := inherited Value + '*('
    + ModflowTypes.GetGridMT3DLakeParamClassType.ANE_ParamName + WriteIndex
    + '=0)'   }

end;

{ TGridSeepage }

class function TGridSeepage.ANE_ParamName: string;
begin
  result := kMFSeepageParam;
end;

constructor TGridSeepage.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

function TGridSeepage.Value: string;
begin
  if frmMODFLOW.cbAltSpg.Checked then
  begin
    result := 'If(CountObjectsInBlock('
           + ModflowTypes.GetMFLineSeepageLayerType.ANE_LayerName + WriteIndex
           + '.' + ModflowTypes.GetMFLineSeepageElevationParamClassType.ANE_ParamName + ',1)>0|'
           + ModflowTypes.GetMFAreaSeepageLayerType.ANE_LayerName
           + WriteIndex + '.'
           + ModflowTypes.GetMFAreaSeepageElevationParamClassType.ANE_ParamName + '!=$N/A, 1, 0)'

  end
  else
  begin

    result := 'If(CountObjectsInBlock('
           + ModflowTypes.GetMFLineSeepageLayerType.ANE_LayerName + WriteIndex
           + '.' + ModflowTypes.GetMFLineSeepageElevationParamClassType.ANE_ParamName + ',1)>0|CountObjectsInBlock('
           + ModflowTypes.GetMFAreaSeepageLayerType.ANE_LayerName + WriteIndex + '.'
           + ModflowTypes.GetMFAreaSeepageElevationParamClassType.ANE_ParamName
           + ',2)>0|' + ModflowTypes.GetMFAreaSeepageLayerType.ANE_LayerName
           + WriteIndex + '.'
           + ModflowTypes.GetMFAreaSeepageElevationParamClassType.ANE_ParamName + '!=$N/A, 1, 0)'
  end;

end;

end.
