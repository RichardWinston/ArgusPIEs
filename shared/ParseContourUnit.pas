unit ParseContourUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Clipbrd, ComCtrls,

  AnePIE, ImportPIE ;


type
  TContourStringList = class(TStringList);
//  end;
  TContour = class(TObject)
    private
      FValueStringList : TStringList;
      FPoints : TStringList;
      function GetValue : string;
      procedure SetValue(ValueString : string);
      function GetAValue(AnIndex : integer) : string;
      procedure SetAValue(AnIndex : integer; AValue : string);
      function GetXCoordinate(AnIndex : integer) : double;
      function GetYCoordinate(AnIndex : integer) : double;
      procedure SetXCoordinate(AnIndex : integer; XCoordinate : double);
      procedure SetYCoordinate(AnIndex : integer; YCoordinate : double);
    published
      property Value : string read GetValue;
    public
      Heading : TStringlist;
      constructor Create;
      Destructor Destroy; override;
      property Values[AnIndex: integer] : string read GetAValue write SetAValue;
      Property XCoordinate[AnIndex : integer] : double
        read GetXCoordinate write SetXCoordinate;
      property YCoordinate[AnIndex : integer] : double
        read GetYCoordinate write SetYCoordinate;
  end;

  TContourList = class(TObject)
    private
      FContourList : TList;
      procedure ParseContours(AString : String);
      function GetCapacity : integer;
      procedure SetCapacity(ACapacity : integer);
      function GetCount : integer;
      procedure SetCount(ACount : integer);
      function GetItems(AnIndex : integer) : TContour;
      procedure SetItems(AnIndex : integer; AContour : TContour);
    public
      constructor Create;
      destructor Destroy; override;
      function  WriteContourStringList : TContourStringList;
      procedure ReadContourFromClipboard ;
      procedure WriteContoursToClipBoard
        (AContourStringList : TContourStringList) ;
      function WriteContourString : string;
      Property Capacity : integer read GetCapacity write SetCapacity;
      Property Count : integer read GetCount write SetCount;
      Property Contours[AnIndex : integer] : TContour
        read GetItems write SetItems;
    end;


{
procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
}
implementation



{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB;




constructor TContourList.Create;
begin
  FContourList := TList.Create;
end;

destructor TContourList.Destroy;
var
   index : integer;
   AContour : TContour;
begin
  For index := FContourList.Count -1 downto 0 do
  begin
    AContour := FContourList.Items[index];
    AContour.Free;
  end;
  FContourList.Clear;
  FContourList.Free;
  inherited;
end;

constructor TContour.Create;
begin
    inherited;
    Heading := TStringlist.Create;
    FPoints := TStringList.Create;
    FValueStringList := TStringList.Create;
end;

destructor TContour.Destroy;
begin
  Heading.Free;
  FPoints.Free;
  FValueStringList.Free;
  inherited;
end;

function TContour.GetValue : string;
var
  index : integer;
begin
  result := '';
  for index := 0 to FValueStringList.Count -1 do
  begin
    result := result + FValueStringList.Strings[index] + Chr(9);
  end;
  result := copy(result, 1, Length(result)-1);
end;

procedure TContour.SetValue(ValueString : string);
var
  AValue : string;
  TabPosition : integer;
begin
  While Pos(Chr(9), ValueString) > 0 do
  begin
    TabPosition := Pos(Chr(9), ValueString);
    AValue := Copy(ValueString, 1, TabPosition - 1);
    ValueString := Copy(ValueString, TabPosition + 1, Length(ValueString));
    FValueStringList.Add(AValue);
  end;
  FValueStringList.Add(ValueString);

end;

function TContour.GetAValue(AnIndex : integer) : string;
begin
  result := FValueStringList.Strings[AnIndex];
end;

procedure TContour.SetAValue(AnIndex : integer; AValue : string);
begin
  if not (FValueStringList.Strings[AnIndex] =  AValue)
  then
    begin
      FValueStringList.Strings[AnIndex] :=  AValue;
    end;
end;

function TContour.GetXCoordinate(AnIndex : integer) : double;
var
  AString : string;
  TabPosition : integer;
begin
  AString := FPoints.Strings[AnIndex];
  TabPosition := Pos(Chr(9), AString);
  AString := Copy(AString, 1, TabPosition - 1);
  result := StrToFloat(AString);
end;

function TContour.GetYCoordinate(AnIndex : integer) : double;
var
  AString : string;
  TabPosition : integer;
begin
  AString := FPoints.Strings[AnIndex];
  TabPosition := Pos(Chr(9), AString);
  AString := Copy(AString, TabPosition + 1, Length(AString));
  result := StrToFloat(AString);
end;

procedure TContour.SetXCoordinate(AnIndex : integer; XCoordinate : double) ;
var
  AString : string;
  TabPosition : integer;
begin
  AString := FPoints.Strings[AnIndex];
  TabPosition := Pos(Chr(9), AString);
  AString := Copy(AString, TabPosition, Length(AString));
  FPoints.Strings[AnIndex] := FloatToStr(XCoordinate) + AString;
end;

procedure TContour.SetYCoordinate(AnIndex : integer; YCoordinate : double) ;
var
  AString : string;
  TabPosition : integer;
begin
  AString := FPoints.Strings[AnIndex];
  TabPosition := Pos(Chr(9), AString);
  AString := Copy(AString,  1, TabPosition);
  FPoints.Strings[AnIndex] := AString + FloatToStr(YCoordinate);
end;

procedure TContourList.ReadContourFromClipboard ;
var
  ContourString : string;
  AClipBoard : TClipboard;
  Size, PreviousSize : integer;
begin
  AClipBoard := TClipboard.Create;
  try
    begin
      PreviousSize := 0;
      Size := 1;
      ContourString := ' ';
      while not (PreviousSize  = Size) do
      begin
        PreviousSize := Size;
        ContourString := ContourString + ContourString + ContourString;
        Size := AClipBoard.GetTextBuf(PChar(ContourString), Size*3);
      end;
      ParseContours(ContourString);
    end;
  finally
    begin
      AClipBoard.Free;
    end;
  end;
end;

procedure TContourList.WriteContoursToClipBoard
  (AContourStringList : TContourStringList) ;
var
  AClipBoard : TClipboard;

begin
  AClipBoard := TClipboard.Create;
  try
    begin
      AClipBoard.SetTextBuf(PChar(AContourStringList.Text));
    end
  finally
    begin
      AClipBoard.Free;
    end;
  end;
end;

procedure TContourList.ParseContours(AString : String) ;
var
  ContourStringList : TContourStringList;
  Index,  HeadingIndex : integer;
  AContour : TContour;
  HeadingTest : boolean;
//  JoinedContourTest : boolean;
//  PointsIndex : integer;
//  NoContoursFreed : boolean;
  ValueString : String;
begin
  ContourStringList := TContourStringList.Create;
  AContour := nil;
  try
    begin
      ContourStringList.Text := AString;
      HeadingTest := True;
      For Index := 0 to ContourStringList.Count -1 do
      begin
        if Pos('## Name:', ContourStringList.Strings[Index]) > 0 then
        begin
          AContour := TContour.Create;
          FContourList.Add(AContour);
          HeadingTest := True;
        end;
        if not (AContour = nil) then
        begin
          if HeadingTest
          then
            begin
              AContour.Heading.Add(ContourStringList.Strings[Index]);
            end
          else
            begin
              if not (ContourStringList.Strings[Index] = '') then
              begin
                AContour.FPoints.Add(ContourStringList.Strings[Index]);
              end;
            end;
          if Pos('# X pos', ContourStringList.Strings[Index]) > 0 then
          begin
            HeadingTest := False;
          end;
        end;
      end;
      For index := 0 to FContourList.Count -1 do
      begin
        AContour := FContourList.Items[index];
        for HeadingIndex := 0 to AContour.Heading.Count -1 do
        begin
          if Pos('# Points Count',
             AContour.Heading.Strings[HeadingIndex]) > 0 then
          begin
            ValueString := AContour.Heading.Strings[HeadingIndex + 1];
            ValueString := Copy(ValueString, Pos(Chr(9), ValueString)+ 1,
                              Length(ValueString));
            AContour.SetValue(ValueString);
            break;
          end;
        end;
      end;
    end;
  finally
    begin
      ContourStringList.Free;
    end;
  end;
end;

// the code that calls WriteContourStringList
// is responsible for freeing the result.
function  TContourList.WriteContourStringList : TContourStringList;
var
  Index ,  HeadingIndex : integer;
  AContour : TContour;
  ContourStringList : TContourStringList;
begin
  ContourStringList := TContourStringList.Create;

  For index := 0 to FContourList.Count -1 do
  begin
    AContour := FContourList.Items[index];
    for HeadingIndex := 0 to AContour.Heading.Count -1 do
    begin
      if Pos('# Points Count', AContour.Heading.Strings[HeadingIndex]) > 0 then
      begin
        AContour.Heading.Strings[HeadingIndex + 1] :=
           IntToStr(AContour.FPoints.Count) + Chr(9) + AContour.Value;
        break;
      end;
    end;
  end;

  ContourStringList.Text := '';
  For index := 0 to FContourList.Count -1 do
  begin
    AContour := FContourList.Items[index];
    AContour.FPoints.Add('');
    ContourStringList.Text := ContourStringList.Text + AContour.Heading.Text
      + AContour.FPoints.Text;
  end;
  result := ContourStringList;


end;

function TContourList.WriteContourString : string;
var
  index : integer;
  AContourStringList : TContourStringList;
begin
  AContourStringList := WriteContourStringList;
  try
    begin
      result := '';
      For index := 0 to AContourStringList.Count -1 do
      begin
        result := result + AContourStringList.strings[index] +  Chr(10);
      end;

      result := result +  Chr(10);
    end
  finally
    begin
      AContourStringList.Free;
    end;
  end;
end;

function TContourList.GetCapacity : integer;
begin
  result := FContourList.Capacity
end;

procedure TContourList.SetCapacity(ACapacity : integer);
begin
  FContourList.Capacity := ACapacity;
end;

function TContourList.GetCount : integer;
begin
  result := FContourList.Count
end;

procedure TContourList.SetCount(ACount : integer);
begin
  FContourList.Capacity := ACount;
end;

function TContourList.GetItems(AnIndex : integer) : TContour;
begin
  result := FContourList.Items[AnIndex]
end;

procedure TContourList.SetItems(AnIndex : integer; AContour : TContour);
begin
  FContourList.Items[AnIndex] := AContour;
end;

end.
