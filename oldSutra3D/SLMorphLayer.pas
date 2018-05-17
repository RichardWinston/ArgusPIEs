unit SLMorphLayer;

interface

Uses ANE_LayerUnit, SLSutraMesh;

type
  TSutraMorphElevation = class(TZParam)
//    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
//    function Units : string; override;
  end;

  TSutraMorphMeshLayer = class(T_ANE_TriMeshLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses SLDomainDensity;

ResourceString
//  kElevation = 'Elevation';
  kMorph = 'Morph Layer Unit';

{ TSutraMorphElevation }

{class function TSutraMorphElevation.ANE_ParamName: string;
begin
  result := kElevation;
end; }

constructor TSutraMorphElevation.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
 inherited;
 ParameterType := mptLayer;
end;

{
function TSutraMorphElevation.Units: string;
begin
  Result := 'L';
end;  }

{ TSutraMorphMeshLayer }

class function TSutraMorphMeshLayer.ANE_LayerName: string;
begin
  result := kMorph;
end;

constructor TSutraMorphMeshLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Template.Add('# editable SUTRA template goes here');

  DomainLayer := TSutraDomainOutline.ANE_LayerName {+ WriteIndex};
  DensityLayer := TSutraMeshDensity.ANE_LayerName {+ WriteIndex};

  TSutraMorphElevation.Create(ParamList,-1);
end;

end.
