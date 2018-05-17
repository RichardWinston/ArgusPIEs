unit frmPriorEquationEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, ComCtrls, StdCtrls, Buttons, ArgusDataEntry, ExtCtrls, Grids,
  DataGrid, Math;

type
  EInvalidName = class(Exception);

  TfrmPriorEquationEditor = class(TArgusForm)
    dgEquationParts: TDataGrid;
    Panel1: TPanel;
    adeParamCount: TArgusDataEntry;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    sbEquation: TStatusBar;
    lblParamCount: TLabel;
    BitBtn3: TBitBtn;
    procedure adeParamCountExit(Sender: TObject);
    procedure dgEquationPartsUserChanged(Sender: TObject);
  private
    function GetSignPosition(EquationString: string): integer;
    function GetAsteriskPosition(EquationString: string): integer;
    function GetSign(var EquationString: string): string;
    function GetCoefficient(var EquationString: string): double;
    function GetSpacePosition(EquationString: string): integer;
    function GetParameterName(var EquationString: string): string;
    { Private declarations }
  public
    function Equation : string;
    function EquationParser(EquationString: string): boolean;
    procedure Intitialize;
    { Public declarations }
  end;

var
  frmPriorEquationEditor: TfrmPriorEquationEditor;

implementation

uses UtilityFunctions;

{$R *.DFM}

procedure TfrmPriorEquationEditor.adeParamCountExit(Sender: TObject);
var
  RowIndex : integer;
begin
  dgEquationParts.RowCount := StrToInt(adeParamCount.Text) + 1;

  for RowIndex := 1 to dgEquationParts.RowCount -1 do
  begin
    if dgEquationParts.Cells[0,RowIndex] = '' then
    begin
      dgEquationParts.Cells[0,RowIndex] := dgEquationParts.Columns[0].PickList[0];
    end;
    if dgEquationParts.Cells[1,RowIndex] = '' then
    begin
      dgEquationParts.Cells[1,RowIndex] := '1';
    end;
    if dgEquationParts.Cells[2,RowIndex] = '' then
    begin
      dgEquationParts.Cells[2,RowIndex] := dgEquationParts.Columns[2].PickList[0];
    end;
  end;


  sbEquation.SimpleText := Equation;

end;

function TfrmPriorEquationEditor.Equation: string;
var
  RowIndex : integer;
  sign, coefficient, Parameter : string;
  CommaPos : integer;
begin
  result := '';
  for RowIndex := 1 to dgEquationParts.RowCount -1 do
  begin
    sign := Trim(dgEquationParts.Cells[0,RowIndex]);
    if sign = '' then
    begin
      sign := '+'
    end;
    if (RowIndex = 1) and (sign = '+') then
    begin
      sign := '';
    end;
    coefficient := Trim(dgEquationParts.Cells[1,RowIndex]);
    if InternationalStrToFloat(coefficient) = 1 then
    begin
      coefficient := '';
    end;
    CommaPos := Pos(',', coefficient);
    if CommaPos > 0 then
    begin
      coefficient[CommaPos] := '.';
    end;

    if coefficient <> '' then
    begin
      coefficient := coefficient + '*'
    end;
    Parameter := Trim(dgEquationParts.Cells[2,RowIndex]);
    if (Parameter = '') and (dgEquationParts.Columns[2].PickList.Count > 0) then
    begin
      Parameter := dgEquationParts.Columns[2].PickList[0];
    end;
    result := result + sign + coefficient + Parameter + ' ';
  end;
  result := Trim(Result);
end;

procedure TfrmPriorEquationEditor.dgEquationPartsUserChanged(
  Sender: TObject);
begin
  sbEquation.SimpleText := Equation;
end;


function TfrmPriorEquationEditor.EquationParser(EquationString : string) : boolean;
var
  RowIndex : integer;
begin
  result := True;
  EquationString := Trim(EquationString);
  RowIndex := 1;
    While Length(EquationString) > 0 do
    begin
      dgEquationParts.RowCount := RowIndex + 1;
      dgEquationParts.Cells[0,RowIndex] := GetSign(EquationString);
      dgEquationParts.Cells[1,RowIndex] := InternationalFloatToStr(GetCoefficient(EquationString));
      Try
        dgEquationParts.Cells[2,RowIndex] := GetParameterName(EquationString);
      Except on E: EInvalidName do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
          result := False;
        end;
      end;
      Inc(RowIndex);
    end;
end;


function TfrmPriorEquationEditor.GetSignPosition(
  EquationString: string): integer;
var
  Index : integer;
  Position : integer;
  AString : string;
begin
  result := 0;
  for Index := 0 to dgEquationParts.Columns[0].PickList.Count-1 do
  begin
    AString := dgEquationParts.Columns[0].PickList[Index];
    Position := Pos(AString,EquationString);
    if (Position > 0) and ((result = 0) or (Position < result)) then
    begin
      result := Position;
    end;
  end;
end;

function TfrmPriorEquationEditor.GetAsteriskPosition(
  EquationString: string): integer;
const
  Asterisk = '*';
begin
  result := Pos(Asterisk,EquationString);;
end;

function TfrmPriorEquationEditor.GetSpacePosition(
  EquationString: string): integer;
const
  Space = ' ';
begin
  result := Pos(Space,EquationString);;
end;

function TfrmPriorEquationEditor.GetSign(
  var EquationString: string): string;
var
  Position : integer;
begin
  Position := GetSignPosition(EquationString);
  if Position = 1 then
  begin
    result := EquationString[1];
    EquationString := Trim(Copy(EquationString, 2, Length(EquationString)));
  end
  else
  begin
    result := '+';
  end;
end;

function TfrmPriorEquationEditor.GetCoefficient(
  var EquationString: string): double;
var
  Position : integer;
  ACoefString : string;
begin
  Position := GetAsteriskPosition(EquationString);
  if Position > 0 then
  begin
    ACoefString := Copy(EquationString,1,Position-1);
    try
      result := InternationalStrToFloat(ACoefString);
      EquationString := Trim(Copy(EquationString,Position + 1,
        Length(EquationString)));
    except on EConvertError do
      result := 1;
    end;
  end
  else
  begin
    result := 1;
  end;
end;

function TfrmPriorEquationEditor.GetParameterName(
  var EquationString: string): string;
var
  SpacePosition, SignPosition, Position : integer;
//  ACoefString : string;
begin
  SpacePosition := GetSpacePosition(EquationString);
  SignPosition := GetSignPosition(EquationString);
  If (SpacePosition > 0) and (SignPosition > 0) then
  begin
    Position := Min(SpacePosition,SignPosition);
  end
  else
  begin
    Position := Max(SpacePosition,SignPosition);
  end;
  if Position > 0 then
  begin
    result := Copy(EquationString,1,Position-1);
    EquationString := Trim(Copy(EquationString,Position,
      Length(EquationString)));
  end
  else
  begin
    result := EquationString;
    EquationString := '';
  end;
  if dgEquationParts.Columns[2].PickList.IndexOf(result) < 0 then
  begin

    raise EInvalidName.Create(result + ' is not a valid parameter name.');
  end;
end;

procedure TfrmPriorEquationEditor.Intitialize;
begin
  dgEquationParts.Cells[0,1] := '+';
  dgEquationParts.Cells[1,1] := '1';
  if dgEquationParts.Columns[2].PickList.Count > 0 then
  begin
    dgEquationParts.Cells[2,1] := dgEquationParts.Columns[2].PickList[0];
  end;
end;

end.
