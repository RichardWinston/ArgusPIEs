unit TimeDataUnit;

interface

uses Classes;

type
  TTimeData = class (TObject)
    Time : double;
    Datum : double;
    end;

  TTimeDataList = class(TObject)
    private
      FList : TList;
      procedure SetItems(Index : integer; ATimeData : TTimeData);
      Function GetItems(Index : integer) : TTimeData;
      function GetCount : Integer;
    public
      constructor Create;
      destructor Destroy; override;
      procedure ReadFromFile(AFileName : string);
      Property Items[Index : integer] : TTimeData Read GetItems Write SetItems;
      Property Count : integer Read GetCount;
    end;


implementation

constructor TTimeDataList.Create;
begin
  FList := TList.Create;
end;

destructor TTimeDataList.Destroy;
var
  ATimeData : TTimeData;
  index : integer;
begin
  for index := FList.Count -1 downto 0 do
  begin
    ATimeData := FList.Items[index];
    ATimeData.Free;
  end;
  FList.Clear;
  FList.Free;
end;

procedure TTimeDataList.ReadFromFile(AFileName : string);
var
  TheFile : TextFile;
  TitleLine : string;
  Time : double;
  DataValue : double;
  ATimeData : TTimeData;
//  AMonth : TMonth;
//  index : integer;
begin
    AssignFile(TheFile, AFileName);
    try
      begin
        Reset(TheFile);
        if not Eof(TheFile) then
        begin
          Readln(TheFile, TitleLine);
        end;
        if not Eof(TheFile) then
        begin
          Readln(TheFile, TitleLine);
        end;
        while not Eof(TheFile) do
        begin
          if not Eof(TheFile) then
          begin
            Read(TheFile, Time);
            ATimeData := TTimeData.Create;
            ATimeData.Time := Time;
            FList.Add(ATimeData);
            if Eof(TheFile) then
            begin
              FList.Delete(FList.Count -1);
              ATimeData.Free;
            end
            else
            begin
                Read(TheFile, DataValue);
                ATimeData.Datum := DataValue;
            end;
          end;
        end;
      end
    finally
      begin
        CloseFile(TheFile);
      end;
    end;
end;

procedure TTimeDataList.SetItems(Index : integer; ATimeData : TTimeData);
begin
  FList.Items[Index] := ATimeData;
end;

Function TTimeDataList.GetItems(Index : integer) : TTimeData;
begin
  result := FList.Items[Index];
end;

function TTimeDataList.GetCount : Integer;
begin
  result := FList.Count;
end;

end.
