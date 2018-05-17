unit SLUcodeFactors;

interface

uses ANE_LayerUnit;

Type
  TUcodeFactorGroup = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

const
  KInverseFormulaFactors = 'Inverse Formula Factors';

{ TUcodeFactorGroup }

class function TUcodeFactorGroup.ANE_LayerName: string;
begin
  result := KInverseFormulaFactors;
end;

end.
