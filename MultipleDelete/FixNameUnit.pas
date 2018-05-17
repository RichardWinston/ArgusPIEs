unit FixNameUnit;

interface

uses Sysutils, Classes;

function FixArgusName (AName : string) : string;
// This function takes AName and replaces each character in AName that would
// be illegal in an Argus layer or parameter name with a '_';

implementation

var
  IllegalCharacterList : TStringList;

function FixArgusName (AName : string) : string;
const
  DigitCount = 10;
  Digits : array[1..DigitCount] of char = ('1', '2', '3', '4', '5', '6', '7',
    '8', '9', '0');
var
  StringIndex : Integer;
  AnIllegalCharacter : String;
  Position : integer;
  DigitIndex : integer;
begin
  AName := Trim(AName);
  for StringIndex := 0 to IllegalCharacterList.Count -1 do
  begin
    AnIllegalCharacter := IllegalCharacterList.Strings[StringIndex];
    Position := Pos(AnIllegalCharacter, AName);
    while (Position > 0) do
    begin
      AName[Position] := '_';
      Position := Pos(AnIllegalCharacter, AName);
    end;
  end;
  If Length(AName) > 0 then
  begin
    for DigitIndex := 1 to DigitCount do
    begin
      if AName[1] = Digits[DigitIndex] then
      begin
        AName[1] := '_';
        break;
      end;
    end;
  end;

  result := AName;
end;

procedure InitializeIllegalCharacters;
begin
  // this creates a list of characters that are illegal in the names
  // assigned to layers or parameters in Argus ONE.
  IllegalCharacterList := TStringList.Create;
  IllegalCharacterList.Add('(');
  IllegalCharacterList.Add(')');
  IllegalCharacterList.Add('[');
  IllegalCharacterList.Add(']');
  IllegalCharacterList.Add('+');
  IllegalCharacterList.Add('-');
  IllegalCharacterList.Add('*');
  IllegalCharacterList.Add('=');
  IllegalCharacterList.Add('/');
  IllegalCharacterList.Add('\');
  IllegalCharacterList.Add('.');
  IllegalCharacterList.Add('&');
  IllegalCharacterList.Add('|');
  IllegalCharacterList.Add('"');
  IllegalCharacterList.Add(',');
  IllegalCharacterList.Add(';');
  IllegalCharacterList.Add('~');
  IllegalCharacterList.Add(':');
  IllegalCharacterList.Add('<');
  IllegalCharacterList.Add('>');
  IllegalCharacterList.Add('?');
  IllegalCharacterList.Add('''');
end;

Initialization
begin
  InitializeIllegalCharacters;
end;

Finalization
begin
  IllegalCharacterList.Free;
end;

end.
