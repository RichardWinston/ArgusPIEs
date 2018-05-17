unit CheckVersionFunction;

interface

uses

  AnePIE, FunctionPie,  SysUtils;

function CheckArgusVersion(const aneHandle : ANE_PTR;
  const MajorToCheck, MinorToCheck, UpdateToCheck : ANE_INT32;
  const VersionToCheck :Char) : Boolean;
  // returns true if the version of Argus ONE running the PIE
  // is greater than or equal to the version specified by
  // MajorToCheck, MinorToCheck, UpdateToCheck and VersionToCheck

implementation

uses ANECB;

function CheckArgusVersion(const aneHandle : ANE_PTR;
  const MajorToCheck, MinorToCheck, UpdateToCheck : ANE_INT32;
  const VersionToCheck : Char) : Boolean;
const StringLength = 50;
var
  ActualMajor : ANE_INT32;
  ActualMinor : ANE_INT32;
  ActualUpdate : ANE_INT32;
  ActualVersion : array[1..StringLength] of Char;
  AString  : string;
begin
  ANE_GetVersion(aneHandle, Addr(ActualMajor) , Addr(ActualMinor),
    Addr(ActualUpdate), @ActualVersion, StringLength );
  result := False;
  if (MajorToCheck < ActualMajor) then
  begin
    Result := True;
  end
  else if MajorToCheck = ActualMajor then
  begin
    if MinorToCheck*10 + UpdateToCheck < ActualMinor then
    begin
      Result := True;
    end
    else if MinorToCheck*10 + UpdateToCheck = ActualMinor then
    begin
      AString := VersionToCheck;
      if Ord(UpperCase(AString)[1]) - Ord('A') + 1 <= ActualUpdate  then
      begin
        Result := True;
      end;
    end
  end;
end;


end.
