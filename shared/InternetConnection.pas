unit InternetConnection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

function ReadInternetFile(const URL_String: string;
  const Lines: TStringList): boolean;

implementation

uses Wininet;

function ReadInternetFile(const URL_String: string;
  const Lines: TStringList): boolean;
var
  Buffer: array[0..4095] of Char;
  Connection, URL: HINTERNET;
  AppName: string;
  Stream: TMemoryStream;
  AmountRead: DWord;
begin
  result := False;
  if InternetAttemptConnect(0) <> ERROR_SUCCESS then
  begin
    ShowMessage('Failed to establish an internet connection.');
    Exit;
  end;

  AppName := ExtractFileName(Application.Name);
  Connection := InternetOpen(PChar(AppName),
    INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    if Connection = nil then
    begin
      RaiseLastWin32Error;
    end;

    URL := InternetOpenUrl(Connection, PChar(URL_String), nil, 0, 0, 0);
    try
      if URL = nil then
      begin
        RaiseLastWin32Error;
      end;
      Stream := TMemoryStream.Create;
      try
        AmountRead := 1;
        while AmountRead > 0 do
        begin
          if not InternetReadFile(URL, @Buffer, SizeOf(Buffer), AmountRead) then
          begin
            RaiseLastWin32Error;
          end;
          Stream.Write(Buffer, AmountRead);
        end;

        Stream.Position := 0;
        Lines.LoadFromStream(Stream);
        result := True;
      finally
        Stream.Free;
      end;
    finally
      if not InternetCloseHandle(URL) then
      begin
        Beep;
        ShowMessage('Failed to close URL');
      end
    end;
  finally
    if not InternetCloseHandle(Connection) then
    begin
      Beep;
      ShowMessage('Failed to close Internet connection');
    end
  end;
end;

end.
