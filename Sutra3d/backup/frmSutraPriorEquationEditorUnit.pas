unit frmSutraPriorEquationEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, ComCtrls, StdCtrls, Buttons, ArgusDataEntry, ExtCtrls, Grids,
  DataGrid, Math, Mask, JvExMask, JvSpin;

type
  EInvalidName = class(Exception);

  TfrmSutraPriorEquationEditor = class(TArgusForm)
    dgEquationParts: TDataGrid;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    sbEquation: TStatusBar;
    lblParamCount: TLabel;
    BitBtn3: TBitBtn;
    seParameterCount: TJvSpinEdit;
    procedure adeParamCountExit(Sender: TObject);
    procedure dgEquationPartsUserChanged(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    function GetPlusPosition(EquationString: string): integer;
    function GetTimesPosition(EquationString: string): integer;
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
  frmSutraPriorEquationEditor: TfrmSutraPriorEquationEditor;

implementation

uses UtilityFunctions, frmSutraUnit;

{$R *.DFM}

const
  Log10 = 'log10(';


procedure TfrmSutraPriorEquationEditor.adeParamCountExit(Sender: TObject);
var
  RowIndex : integer;
begin
  dgEquationParts.RowCount := seParameterCount.AsInteger + 1;

  for RowIndex := 1 to dgEquationParts.RowCount -1 do
  begin
    if dgEquationParts.Cells[0,RowIndex] = '' then
    begin
      dgEquationParts.Cells[0,RowIndex] := '1';
    end;
    if dgEquationParts.Cells[1,RowIndex] = '' then
    begin
      dgEquationParts.Cells[1,RowIndex] := dgEquationParts.Columns[1].PickList[0];
    end;
  end;

  sbEquation.SimpleText := Equation;
end;

function TfrmSutraPriorEquationEditor.Equation: string;
var
  RowIndex : integer;
  Sign, coefficient, Parameter : string;
  CommaPos : integer;
  ParamRow: integer;
begin
  result := '';
  for RowIndex := 1 to dgEquationParts.RowCount -1 do
  begin
    if (RowIndex = 1) then
    begin
      sign := '';
    end
    else
    begin
      sign := ' + ';
    end;

    coefficient := Trim(dgEquationParts.Cells[0,RowIndex]);
    CommaPos := Pos(',', coefficient);
    if CommaPos > 0 then
    begin
      coefficient[CommaPos] := '.';
    end;

    coefficient := coefficient + ' * ';
    Parameter := Trim(dgEquationParts.Cells[1,RowIndex]);
    if (Parameter = '') and (dgEquationParts.Columns[1].PickList.Count > 0) then
    begin
      Parameter := dgEquationParts.Columns[1].PickList[0];
    end;
    ParamRow := frmSutra.dgEstimate.Cols[Ord(ucParameter)].IndexOf(Parameter);
    if ParamRow >= 1 then
    begin
      if frmSutra.dgEstimate.Checked[Ord(ucLog), ParamRow] then
      begin
        Parameter := Log10 + Parameter + ')';
      end;
    end;

    result := result + sign + coefficient + Parameter;
  end;
  result := Trim(Result);
end;

procedure TfrmSutraPriorEquationEditor.dgEquationPartsUserChanged(
  Sender: TObject);
begin
  sbEquation.SimpleText := Equation;
end;


function TfrmSutraPriorEquationEditor.EquationParser(EquationString : string) : boolean;
var
  RowIndex : integer;
begin
  result := True;
  EquationString := Trim(EquationString);
  RowIndex := 1;
  While Length(EquationString) > 0 do
  begin
    dgEquationParts.RowCount := RowIndex + 1;
    GetSign(EquationString);
    dgEquationParts.Cells[0,RowIndex] := FloatToStr(GetCoefficient(EquationString));
    Try
      dgEquationParts.Cells[1,RowIndex] := GetParameterName(EquationString);
    Except on E: EInvalidName do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
        result := False;
      end;
    end;
    Inc(RowIndex);
  end;
  seParameterCount.AsInteger := dgEquationParts.RowCount-1;
end;


function TfrmSutraPriorEquationEditor.GetPlusPosition(
  EquationString: string): integer;
var
  Position : integer;
  AString : string;
begin
  result := 0;
  AString := '+';
  Position := Pos(AString,EquationString);
  if (Position > 0) and ((result = 0) or (Position < result)) then
  begin
    result := Position;
  end;
end;

function TfrmSutraPriorEquationEditor.GetTimesPosition(
  EquationString: string): integer;
const
  Asterisk = '*';
begin
  result := Pos(Asterisk,EquationString);;
end;

function TfrmSutraPriorEquationEditor.GetSpacePosition(
  EquationString: string): integer;
const
  Space = ' ';
begin
  result := Pos(Space,EquationString);;
end;

function TfrmSutraPriorEquationEditor.GetSign(
  var EquationString: string): string;
var
  Position : integer;
begin
  Position := GetPlusPosition(EquationString);
  if Position = 1 then
  begin
    result := EquationString[1];
    EquationString := Trim(Copy(EquationString, 2, MAXINT));
  end
  else
  begin
    result := '+';
  end;
end;

function TfrmSutraPriorEquationEditor.GetCoefficient(
  var EquationString: string): double;
var
  Position : integer;
  ACoefString : string;
begin
  Position := GetTimesPosition(EquationString);
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

function TfrmSutraPriorEquationEditor.GetParameterName(
  var EquationString: string): string;
var
  SpacePosition, SignPosition, Position : integer;
begin
  SpacePosition := GetSpacePosition(EquationString);
  SignPosition := GetPlusPosition(EquationString);
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

  if Pos(Log10, result) = 1 then
  begin
    Assert(result[Length(result)] = ')');
    result := Copy(result, Length(Log10)+1, Length(result)-Length(Log10) -1);
  end;

  if dgEquationParts.Columns[1].PickList.IndexOf(result) < 0 then
  begin
    raise EInvalidName.Create(result + ' is not a valid parameter name.');
  end;
end;

procedure TfrmSutraPriorEquationEditor.Intitialize;
begin
  dgEquationParts.Cells[0,1] := '1';
  if dgEquationParts.Columns[1].PickList.Count > 0 then
  begin
    dgEquationParts.Cells[1,1] := dgEquationParts.Columns[1].PickList[0];
  end;
end;

procedure TfrmSutraPriorEquationEditor.BitBtn3Click(Sender: TObject);
begin
  inherited;
  ShowMessage('Sorry; help for this is implemented yet.  Complain to rbwinst@usgs.gov');
end;

end.
