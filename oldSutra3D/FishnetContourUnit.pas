unit FishnetContourUnit;

interface

uses Classes, SysUtils, IntListUnit, BoundaryContourUnit;

type
  TFishnetContour = class(TBoundaryContour)
    private
      FValueList : TIntegerList;
      function GetValue(Index : integer) : Integer;
    public
      constructor Create(Lines : TStrings;
        FirstIndex, SecondIndex : integer);
      Destructor Destroy; override;
      Property Values[Index : integer] : integer read GetValue;
  end;

implementation

{ TFishnetContour }

constructor TFishnetContour.Create(Lines: TStrings;
  FirstIndex, SecondIndex : integer);
  function GetValue(AString : string) : integer;
  begin
    if AString = '$N/A' then
    begin
      result := 0;
    end
    else
    begin
      result := StrToInt(AString);
    end;
  end;
var
  Index : Integer;
  AString : String;
  LineIndex : integer;
//  PointCount : integer;
  XCount, YCount : integer;
  ValueIndex : integer;
  ValueString : string;
  PreviousBreakIndex : integer;

begin
  inherited Create(Lines);
  FValueList := TIntegerList.Create;
  LineIndex := 0;
  for Index := 0 to Lines.Count-1 do
  begin
    if Pos('# X pos',Lines[Index]) = 1 then
    begin
      LineIndex := Index;
      break;
    end;
  end;
//  PointCount := 0;
  AString := Lines[LineIndex -1];
  for Index := 1 to Length(AString) do
  begin
    if (AString[Index] = Chr(9)) or (AString[Index] = ' ') then
    begin
//      PointCount := StrToInt(Copy(AString,1,Index-1));
      AString := Trim(Copy(AString,Index+1,Length(AString)));
      break;
    end;
  end;

  ValueIndex := 0;
  PreviousBreakIndex := 0;
  XCount := 0;
  YCount := 0;
  for Index := 1 to Length(AString) do
  begin
    if (AString[Index] = Chr(9)) or (AString[Index] = ' ') then
    begin
      ValueString := UpperCase(Trim(Copy(AString,PreviousBreakIndex+1,Index-1-PreviousBreakIndex)));
      if ValueIndex = FirstIndex then
      begin
        Try
          XCount := GetValue(ValueString);
        Except on EConvertError do
          begin
            XCount := 0;
          end;
        end;
      end;
      if ValueIndex = SecondIndex then
      begin
        Try
          YCount := GetValue(ValueString);
        Except on EConvertError do
          begin
            YCount := 0;
          end;
        end;
      end;
      PreviousBreakIndex := Index;
//      AString := Trim(Copy(AString,Index+1,Length(AString)))
      Inc(ValueIndex);
//      YCount := StrToInt();
//      break;
    end;
    if Index = Length(AString) then
    begin
      ValueString := UpperCase(Trim(Copy(AString,PreviousBreakIndex+1,Length(AString))));
      if ValueIndex = FirstIndex then
      begin
        Try
          XCount := GetValue(ValueString);
//          XCount := StrToInt(ValueString);
        Except on EConvertError do
          begin
            XCount := 0;
          end;
        end;
      end;
      if ValueIndex = SecondIndex then
      begin
        Try
          YCount := GetValue(ValueString);
        Except on EConvertError do
          begin
            YCount := 0;
          end;
        end;
      end;
//      PreviousBreakIndex := Index;
//      AString := Trim(Copy(AString,Index+1,Length(AString)))
//      Inc(ValueIndex);
//      YCount := StrToInt();
//      break;
    end;
  end;
  FValueList.Add(XCount);
  FValueList.Add(YCount);

end;

destructor TFishnetContour.Destroy;
begin
  FValueList.Free;
  inherited;

end;

function TFishnetContour.GetValue(Index: integer): Integer;
begin
  result := FValueList.Items[Index];
end;



end.
