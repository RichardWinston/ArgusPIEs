unit MonthlyDataUnit;

interface

uses IntListUnit, classes, RealListUnit, SysUtils, Dialogs;

Type
  TMonth = (mJan, mFeb, mMar, mApril, mMay, mJune,
            mJuly, mAug, mSept, mOct, mNov, mDec);

  TAnnualData = Class(TObject)
    private
      FYear : integer;
      FJanData : double;
      FFebData : double;
      FMarData : double;
      FAprilData : double;
      FMayData : double;
      FJuneData : double;
      FJulyData : double;
      FAugData : double;
      FSeptData : double;
      FOctData : double;
      FNovData : double;
      FDecData : double;
      procedure SetYear(AYear : integer);
      procedure SetMonthlyData(AMonth : TMonth; ADataValue : double);
      function GetMonthlyData(AMonth : TMonth) : double;
    public
      property Year : integer  read FYear write SetYear;
      property MonthlyData[AMonth : TMonth] : double
        read GetMonthlyData write SetMonthlyData;
      function DaysPerMonth(AMonth : TMonth) : integer;
      function DaysPerYear : integer;
  end;

  TAnnualDataList = Class(Tobject)
    private
      FList : TList;
      function GetAnnualData(YearIndex : integer) : TAnnualData;
      Procedure setAnnualData(YearIndex : integer; AnAnnualData : TAnnualData );
      procedure SetCount(ACount : integer);
      function GetCount: integer;
      procedure SetCapacity(ACapacity : integer);
      function GetCapacity: integer;
    public
      constructor Create;
      destructor Destroy; override;
      property AnnualData[YearIndex : integer] : TAnnualData
        read GetAnnualData write setAnnualData;
      property Capacity : Integer read GetCapacity write SetCapacity;
      property Count : Integer read GetCount write SetCount;
      function Add(AnAnnualData :  TAnnualData) : integer;
      procedure Clear;
      procedure Delete(Index: Integer);
      procedure Exchange(Index1, Index2: Integer);
      function IndexOf(AnAnnualData :  TAnnualData): Integer;
      procedure Move(CurIndex, NewIndex: Integer);
      procedure Pack;
      procedure ReadFromFile(AMonthlyTextFile : string);
      function Remove(AnAnnualData :  TAnnualData): Integer;
    end;



Function GetDaysPerMonth(Year : integer; Month : TMonth) : integer;

implementation



Function GetDaysPerMonth(Year : integer; Month : TMonth) : integer;
begin
  case Month of
    mJan, mMar, mMay, mJuly, mAug, mOct, mDec :
      begin
        result := 31;
      end;
    mApril, mJune, mSept, mNov :
      begin
        result := 30;
      end;
    mFeb :
      begin
        if ((Trunc(Year/4) = Year/4) and (not (Trunc(Year/100) = Year/100)))
           or (Trunc(Year/400) = Year/400)
        then
          begin
            result := 29;
          end
        else
          begin
            result := 28;
          end;
      end;
    else
      begin
        raise ERangeError.Create('Invalid Month');;
      end;
  end;
end;

procedure TAnnualData.SetYear(AYear : integer);
begin
  if not (AYear = FYear) then
  begin
    if AYear < 1582 // 1582 is the year the Gregorian calendar was introduced.
    then
      begin
        raise ERangeError.Create('Invalid Year. ' +
              'All years must be 1582 or larger');
      end
    else
      begin
        FYear := AYear;
      end;
  end;

end;

procedure TAnnualData.SetMonthlyData(AMonth : TMonth; ADataValue : double);
begin
  case AMonth of
    mJan:
      begin
        if not (FJanData = ADataValue) then
        begin
          FJanData := ADataValue;
        end;
      end;
    mFeb:
      begin
        if not (FFebData = ADataValue) then
        begin
          FFebData := ADataValue;
        end;
      end;
    mMar:
      begin
        if not (FMarData = ADataValue) then
        begin
          FMarData := ADataValue;
        end;
      end;
    mApril:
      begin
        if not (FAprilData = ADataValue) then
        begin
          FAprilData := ADataValue;
        end;
      end;
    mMay:
      begin
        if not (FMayData  = ADataValue) then
        begin
          FMayData  := ADataValue;
        end;
      end;
    mJune:
      begin
        if not (FJuneData = ADataValue) then
        begin
          FJuneData := ADataValue;
        end;
      end;
    mJuly:
      begin
        if not (FJulyData = ADataValue) then
        begin
          FJulyData := ADataValue;
        end;
      end;
    mAug:
      begin
        if not (FAugData = ADataValue) then
        begin
          FAugData := ADataValue;
        end;
      end;
    mSept:
      begin
        if not (FSeptData = ADataValue) then
        begin
          FSeptData := ADataValue;
        end;
      end;
    mOct:
      begin
        if not (FOctData = ADataValue) then
        begin
          FOctData := ADataValue;
        end;
      end;
    mNov:
      begin
        if not (FNovData = ADataValue) then
        begin
          FNovData := ADataValue;
        end;
      end;
    mDec:
      begin
        if not (FDecData = ADataValue) then
        begin
          FDecData := ADataValue;
        end;
      end;
    else
      begin
        raise ERangeError.Create('Invalid Month');;
      end;
  end;

end;

function TAnnualData.GetMonthlyData(AMonth : TMonth) : double;
begin
  case AMonth of
    mJan:
      begin
          result := FJanData;
      end;
    mFeb:
      begin
        result := FFebData;
      end;
    mMar:
      begin
        result := FMarData;
      end;
    mApril:
      begin
        result := FAprilData
      end;
    mMay:
      begin
        result := FMayData;
      end;
    mJune:
      begin
        result := FJuneData;
      end;
    mJuly:
      begin
        result := FJulyData;
      end;
    mAug:
      begin
        result := FAugData;
      end;
    mSept:
      begin
        result := FSeptData;
      end;
    mOct:
      begin
        result := FOctData;
      end;
    mNov:
      begin
        result := FNovData;
      end;
    mDec:
      begin
        result := FDecData;
      end;
    else
      begin
        raise ERangeError.Create('Invalid Month');;
      end;
  end;
end;

function TAnnualData.DaysPerMonth(AMonth : TMonth) : integer;
begin
  result := GetDaysPerMonth(FYear, AMonth );
end;

function TAnnualData.DaysPerYear : integer;
begin
  if DaysPerMonth(mFeb)= 28
  then
    begin
      result := 365;
    end
  else
    begin
      result := 366;
    end;
end;

constructor TAnnualDataList.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TAnnualDataList.Destroy;
var
  index : integer;
  AnAnnualData : TAnnualData;
begin
  For index := FList.Count-1 downto 0 do
  begin
    AnAnnualData := FList[index];
    AnAnnualData.Free;
  end;
  Clear;
  FList.Free;
  inherited;
end;

function TAnnualDataList.GetAnnualData(YearIndex : integer) : TAnnualData;
begin
  result := FList.Items[YearIndex]
end;
Procedure TAnnualDataList.setAnnualData(YearIndex : integer;
          AnAnnualData : TAnnualData );
begin
  if not (FList.Items[YearIndex] = AnAnnualData) then
  begin
     FList.Items[YearIndex] := AnAnnualData
  end;
end;

procedure TAnnualDataList.SetCount(ACount : integer);
begin
  FList.Count := ACount;
end;

function TAnnualDataList.GetCount: integer;
begin
  result := FList.Count;
end;

procedure TAnnualDataList.SetCapacity(ACapacity : integer);
begin
  FList.Capacity := ACapacity;
end;

function TAnnualDataList.GetCapacity: integer;
begin
  result := FList.Capacity;
end;

function TAnnualDataList.Add(AnAnnualData :  TAnnualData) : integer;
begin
  result := FList.Add(AnAnnualData);
end;

procedure TAnnualDataList.Clear;
begin
  FList.Clear;
end;

procedure TAnnualDataList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

procedure TAnnualDataList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TAnnualDataList.IndexOf(AnAnnualData :  TAnnualData): Integer;
begin
  result := FList.IndexOf(AnAnnualData);
end;

procedure TAnnualDataList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TAnnualDataList.Pack;
begin
  FList.Pack;
end;

function TAnnualDataList.Remove(AnAnnualData :  TAnnualData): Integer;
begin
  result := FList.Remove(AnAnnualData);
end;

procedure TAnnualDataList.ReadFromFile(AMonthlyTextFile : string);
var
  MonthlyFile : TextFile;
  TitleLine : string;
  Year : integer;
  DataValue : double;
  AnAnnualData : TAnnualData;
  AMonth : TMonth;
  line : integer;
//  index : integer;
begin
    AssignFile(MonthlyFile, AMonthlyTextFile);
    line := 0;
    try
      begin
        Reset(MonthlyFile);
        if not Eof(MonthlyFile) then
        begin
          Inc(line);
          Readln(MonthlyFile, TitleLine);
        end;

        if not Eof(MonthlyFile) then
        begin
          Inc(line);
          Readln(MonthlyFile, TitleLine);
        end;

        while not Eof(MonthlyFile) do
        begin
          if not Eof(MonthlyFile) then
          begin
            try
              begin
                Inc(line);
                Read(MonthlyFile, Year);
              end;
            except on Exception do
              begin
                ShowMessage('Error reading year on line ' + IntToStr(Line));
                raise;
              end;
            end;
            if not (Year = 0) then
            begin
              AnAnnualData := TAnnualData.Create;
              AnAnnualData.Year := Year;
              Add(AnAnnualData);
              if not Eof(MonthlyFile) then
              begin
                for AMonth := mJan to mDec do
                begin
                  Try
                    begin
                      Read(MonthlyFile, DataValue);
                    end
                  except
                    on Exception do
                    begin
                      ShowMessage('Error reading monthly data for the year '
                        + IntToStr(Year) + ' for month number '
                        + IntToStr(Ord(AMonth) + 1));
                      raise;
                    end;
                  end;
                  AnAnnualData.MonthlyData[AMonth] := DataValue;
                end;
              end;
            end;
          end;
        end;
      end
    finally
      begin
        CloseFile(MonthlyFile);
      end;
    end;
end;

end.
