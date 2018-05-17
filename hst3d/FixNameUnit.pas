unit FixNameUnit;

interface

uses Classes;

function FixArgusName (AName : string) : string;

implementation

function FixArgusName (AName : string) : string;
var
  IllegalCharacterList : TStringList;
  StringIndex : Integer;
  AnIllegalCharacter : String;
begin
    IllegalCharacterList := TStringList.Create;
    try
      begin
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

        for StringIndex := 0 to IllegalCharacterList.Count -1 do
        begin
          AnIllegalCharacter := IllegalCharacterList.Strings[StringIndex];
          while (Pos(AnIllegalCharacter, AName) > 0) do
          begin
            AName := Copy(AName, 1, Pos(AnIllegalCharacter, AName)-1)
                     + '_'
                     + Copy(AName, Pos(AnIllegalCharacter, AName)+1,
                       Length(AName));
          end;
        end;

      end;
    finally
      begin
        IllegalCharacterList.Free;
        result := AName;
      end;
    end;
end;

end.
