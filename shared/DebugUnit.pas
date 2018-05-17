unit DebugUnit;

interface
{$IFDEF Debug}

uses sysutils, Dialogs, AnePIE, ANECB;

procedure WriteDebugOutput(AString : string);
function GetArgusVersion(const aneHandle : ANE_PTR) : string;

{$ENDIF}
implementation
{$IFDEF Debug}

uses UtilityFunctions, VersInfo;

var
  FFile : TextFile;
  FileName : string;
  FileOpened: boolean;

procedure WriteDebugOutput(AString : string);
begin
  WriteLn(FFile, '------------------------------------');
  WriteLn(FFile, AString);
  Flush(FFile);
end;

function GetArgusVersion(const aneHandle : ANE_PTR) : string;
const
  StringLength = 50;
var
  ActualMajor : ANE_INT32;
  ActualMinor : ANE_INT32;
  ActualUpdate : ANE_INT32;
  ActualVersion : array[1..StringLength] of Char;
begin
  ANE_GetVersion(aneHandle, Addr(ActualMajor) , Addr(ActualMinor),
    Addr(ActualUpdate), @ActualVersion, StringLength );
  result := ActualVersion;
end;

function GetPIEVersion : String;
var
  VersionInfo1: TVersionInfo;
begin
  VersionInfo1 := TVersionInfo.Create(nil);
  try
    VersionInfo1.FileName := GetDLLName;
    result := VersionInfo1.FileVersion;
  finally
    VersionInfo1.Free;
  end;
end;



initialization
  FileOpened := False;
  FileName := DllAppDirectory(Self.handle, DLLName);
  if not DirectoryExists(FileName) then
  begin
    CreateDirectoryAndParents(FileName);
  end;

//  if GetDllDirectory(GetDLLName, FileName) then
//  begin
    FileName := FileName + '\Debug.txt';
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDebugOutput(GetPIEVersion);
      FileOpened := True;
    except on E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
//  end;

finalization
  if FileOpened then
  begin
    WriteDebugOutput('Closing ' + FileName);
    CloseFile(FFile);
  end;
{$ENDIF}
end.
