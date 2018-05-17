unit ValueFileUnit;

interface

uses
  Classes, SysUtils;

type
  TValue = Class(TObject)
    private
      Key : string;
      Next : TValue;
      Value : double;
      Comments : TStringList;
      Class Function HashIndex(AKey: string; Max : integer): integer;
    public
      Constructor Create(AKey : string; AValue : double);
      Destructor Destroy; override;
  end;

  TFileValues = Class(TObject)
  private
    ValueList : TList;
    FileName : string;
    Comments : TStringList;
    procedure ReadFile;
    Procedure SaveFile;
    procedure ClearValues;
    function GetValue(AKey: string; var Value : double): Boolean;
    Procedure AddValue(AValue : TValue);
  public
    Constructor Create(AFileName : string);
    Destructor Destroy; override;
  end;

  TFileList = Class(TList)
    private
      function GetValueList(AFileName : string) : TFileValues;
    public
      Destructor Destroy; override;
      procedure ClearFiles;
      procedure SaveFiles;
      function GetValue(FileName, Key : string; DefaultValue : double) : double;
//      function GetNAValue(FileName, Key : string; var result : double) : boolean; 
  end;

var
  FileList : TFileList;

implementation

Const
  NumLinesPerValue = 2;

procedure TFileValues.AddValue(AValue: TValue);
var
  HashIndex : integer;
begin
      HashIndex :=  AValue.HashIndex(AValue.Key, ValueList.Count);
      if ValueList.Items[HashIndex] <> nil then
      begin
        AValue.Next := TValue(ValueList.Items[HashIndex]);
      end;
      ValueList.Items[HashIndex] := AValue;

end;

procedure TFileValues.ClearValues;
var
  Index : integer;
begin
  For Index := 0 to ValueList.count -1 do
  begin
    TValue(ValueList[Index]).Free;
  end;
  ValueList.Clear;
  Comments.Clear;
end;

constructor TFileValues.Create(AFileName : string);
begin
  inherited Create;
  FileName := AFileName;
  ValueList := TList.Create;
  Comments := TStringList.Create;
  if FileExists(AFileName) then
  begin
    ReadFile;
  end
  else
  begin
    ValueList.Count := 30;
  end;
end;

destructor TFileValues.Destroy;
begin
  ClearValues;
  ValueList.Free;
  Comments.Free;
  inherited Destroy;
end;

function TFileValues.GetValue(AKey: string; var Value : double): Boolean;
var
  HashIndex : integer;
  AValue : TValue;
begin
  result := False;
  HashIndex := TValue.HashIndex(AKey, ValueList.Count);
  AValue := ValueList[HashIndex];
  while AValue <> nil do
  begin
    if AValue.Key = AKey then
    begin
      Value := AValue.Value;
      result := True;
      break;
    end
    else
    begin
      AValue := AValue.Next;
    end;
  end;
end;

Procedure TFileValues.ReadFile;
var
  AStringList : TStringList;
  Index : integer;
  AValue : TValue;
  Key : string;
  Value : double;
  ALine: string;
  Code: integer;
begin
  AStringList := TStringList.Create;
  try
    if FileExists(FileName) then
    begin
      AStringList.LoadFromFile(FileName);
      ClearValues;
      ValueList.Count :=  AStringList.Count;
      Index := 0;
      AValue := nil;
      While Index < AStringList.Count do
      begin
        if (Trim(AStringList[Index]) = '')  or (AStringList[Index][1] = '#') then
        begin
          if AValue = nil then
          begin
            Comments.Add(AStringList[Index]);
          end
          else
          begin
            AValue.Comments.Add(AStringList[Index]);
          end;
        end
        else
        begin
          Key := AStringList.Strings[Index];
          ALine := AStringList.Strings[Index+1];
          Val(ALine, Value, Code);
          if Code > 0 then
          begin
            Beep;
          end
          else
          begin
            AValue := TValue.Create(Key, Value);
            AddValue(AValue);
          end;
          Inc(Index);
        end;
        Inc(Index);
      end;
    end;

  finally
    AStringList.Free;
  end;

end;

procedure TFileValues.SaveFile;
var
  AStringList : TStringList;
  Index : Integer;
  AValue : TValue;
begin
  AStringList := TStringList.Create;
  try
    AStringList.AddStrings(Comments);
    for Index := 0 to ValueList.Count -1 do
    begin
      AValue := ValueList[Index];
      While AValue <> nil do
      begin
        AStringList.Add(AValue.Key);
        AStringList.Add(FloatToStr(AValue.Value));
        AStringList.AddStrings(AValue.Comments);
        AValue := AValue.Next;
      end;

    end;
    AStringList.SaveToFile(FileName);
  finally
    AStringList.Free;
  end;
end;

{ TValue }

constructor TValue.Create(AKey: string; AValue: double);
begin
  inherited Create;
  Key := Akey;
  Value := AValue;
  Comments := TStringList.Create;
end;

destructor TValue.Destroy;
begin
  Next.Free;
  Comments.Free;
  inherited Destroy;
end;


class function TValue.HashIndex(AKey: string; Max : integer): integer;
Const
  c = 0.618034;
var
  Index, Sum : integer;
begin
  Sum := 0;
  For Index := 1 to Length(AKey) do
  begin
    Sum := Sum + Ord(AKey[Index])
  end;
  result := trunc((Max)*frac(c*Sum));
end;


{ TFileList }

procedure TFileList.ClearFiles;
var
  Index : Integer;
begin
  For Index := Count -1 downto 0 do
  begin
    TFileValues(Items[Index]).Free;
  end;
  Clear;
end;

destructor TFileList.Destroy;
begin
  ClearFiles;
  inherited Destroy;

end;

function TFileList.GetValue(FileName, Key: string;
  DefaultValue: double): double;
var
  AFileValues : TFileValues;
  AValue : TValue;
begin
  AFileValues := GetValueList(FileName);
  if AFileValues = nil then
  begin
    AFileValues := TFileValues.Create(FileName);
    Add(AFileValues);
  end;
  if not AFileValues.GetValue(Key, result) then
  begin
    AValue := TValue.Create(Key, DefaultValue);
    AFileValues.AddValue(AValue);
    result := DefaultValue;
  end;
end;

function TFileList.GetValueList(AFileName: string): TFileValues;
var
  Index : integer;
begin
  result := nil;
  For Index := 0 to Count -1 do
  begin
    result := Items[Index];
    if result.FileName = AFileName then
    begin
      break;
    end;
  end;
end;

procedure TFileList.SaveFiles;
var
  Index : Integer;
  AFileValues : TFileValues;
begin
  for Index := 0 to Count -1 do
  begin
    AFileValues := Items[Index];
    AFileValues.SaveFile;
  end;
end;

initialization
begin
  FileList := TFileList.Create;
end;

finalization
begin
  FileList.Free;
end;

end.
