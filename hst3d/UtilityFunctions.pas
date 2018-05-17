unit UtilityFunctions;

interface

uses Windows, SysUtils, AnePIE;

// ProcessEvents refreshes the ArgusONE window. "CurrentModelHandle"
// (declared in ANE_LayerUnit) must be correct for this to work.
Procedure ProcessEvents(CurrentModelHandle : ANE_PTR);

// GetDllFullPath is used to determine the full file path of a running dll
//  at runtime.
//  FileName is the name of the dll file without the path.
//  FullPath is the name of the dll file with the path.
//  GetDllFullPath returns true if the function succeeds.
// The full path may be up to 1024 characters in length.

function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;

// GetDllDirectory is used to determine the directory containing a running dll
//  at runtime.
//  FileName is the name of the dll file without the path.
//  DllDirectory is the name of the directory containing the dll with
//   no terminating slash.
//  GetDllDirectory returns true if the function succeeds.
// The directory name may be up to 1024 characters in length minus
//  (the length of the file name plus one).

function GetDllDirectory(FileName :string ;
  var DllDirectory : String) : boolean ;

// GetDecChar gets the character used as a decimal separator in the local language.
function GetDecChar : Char;

// LocalStrToFloat converts a string to a floating point value even if
// the character used as a decimal separator in the local language is not '.'
function LocalStrToFloat(const S: string): Extended;

implementation

uses ANE_LayerUnit, ANECB;

Procedure ProcessEvents(CurrentModelHandle : ANE_PTR);
begin
  ANE_ProcessEvents(CurrentModelHandle);
end;

function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;
var
  Index : integer;
   buf : PChar ;
   bufLen : Integer;
   AString : string;
   AHandle : HWND;
begin
      FullPath := '';
      AHandle := GetModuleHandle(PChar(FileName))  ;
      if AHandle = 0
      then
        begin
          Result := False;
        end
      else
        begin
          AString := '1';
          For Index := 1 to 10 do
          begin
            AString := AString + AString;
          end;
          buf := PChar(AString);
          bufLen := Length(AString);
          if (GetModuleFileName(AHandle, buf, bufLen) > 0)
          then
            begin
              FullPath := String(buf);
              Result := True;
            end
          else
            begin
              Result := False;
            end;
        end;

end;

function GetDllDirectory(FileName :string ;
  var DllDirectory : String) : boolean ;
begin
  result :=  GetDllFullPath(FileName ,  DllDirectory );
  DllDirectory := ExtractFileDir(DllDirectory);
end;

// gets the character used as a decimal separator in the local language.
function GetDecChar : Char;
VAR
  SelectedLCID : LCID;
  AString : string;
begin
  SelectedLCID := GetUserDefaultLCID;
  AString := GetLocaleStr(SelectedLCID, LOCALE_SDECIMAL, '.');
  result := AString[1];
end;

function LocalStrToFloat(const S: string): Extended;
var
  DecimalPosition : integer;
  DecimalChar : string;
  AString : string;
begin
  AString := S;
  DecimalChar := GetDecChar;
  if (DecimalChar = '.') then
  begin
    DecimalPosition := Pos(',', S);
    if DecimalPosition > 0
    then
      begin
        AString := Copy(S, 1, DecimalPosition -1) + DecimalChar
          + Copy(S, DecimalPosition + 1, Length(S));
      end;
  end
  else
  begin
    DecimalPosition := Pos('.', S);
    if DecimalPosition > 0
    then
      begin
        AString := Copy(S, 1, DecimalPosition -1) + DecimalChar
          + Copy(S, DecimalPosition + 1, Length(S));
      end;
  end;
  result := StrToFloat(AString);
end;


end.
