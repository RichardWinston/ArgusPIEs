unit frmMultiplierEditUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, Grids, Buttons, StdCtrls, ExtCtrls;

type
  TfrmMultiplierEditor = class(TArgusForm)
    memoFunction: TMemo;
    Panel1: TPanel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    Panel2: TPanel;
    sgDefinedArrays: TStringGrid;
    Splitter1: TSplitter;
    Panel3: TPanel;
    btnPlus: TButton;
    btnMinus: TButton;
    btnMulitply: TButton;
    btnDivide: TButton;
    BitBtn1: TBitBtn;
    procedure btnPlusClick(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
    procedure btnMulitplyClick(Sender: TObject);
    procedure btnDivideClick(Sender: TObject);
    procedure sgDefinedArraysDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    function GetFirstBreak(const FormulaString : string): integer;
    function ParameterOK(Parameter: string): boolean;
    function ArgusArrayFormula(const Row: integer): string;
    function ConstantValue(const Row: integer): string;
    function FormulaValue(const Row: integer): string;
    { Private declarations }
  public
    Procedure InsertText(Sender : TObject; AString : string);
    function Formula : String;
    function FormulaOk(var UnrecognizedString : string; var SelStart, SelLength : integer): boolean;
    function ArgusFormula(const Row : integer): string; overload;
    function ArgusFormula(const MultName : string): string; overload;
    { Public declarations }
  end;

var
  frmMultiplierEditor: TfrmMultiplierEditor;

implementation

{$R *.DFM}

uses Variables, UtilityFunctions;

var
  BreakPoints : array[0..3] of char = ('+', '-', '*', '/');

{ TfrmMultiplierEditor }

procedure TfrmMultiplierEditor.InsertText(Sender : TObject; AString: string);
var
  Contents : string;
  SelStart, SelLength : integer;
begin
  Contents := memoFunction.Text;
  SelStart := memoFunction.SelStart;
  memoFunction.Text := Copy(Contents, 1, memoFunction.SelStart)
    + AString + Copy(Contents, SelStart + memoFunction.SelLength + 1,
      Length(Contents));
  SelLength := Length(AString);
  memoFunction.SelStart := SelStart + SelLength;
  memoFunction.SelLength := 0;
  memoFunction.SetFocus;
end;

procedure TfrmMultiplierEditor.btnPlusClick(Sender: TObject);
begin
  InsertText(self, ' + ')
end;

procedure TfrmMultiplierEditor.btnMinusClick(Sender: TObject);
begin
  InsertText(self, ' - ')

end;

procedure TfrmMultiplierEditor.btnMulitplyClick(Sender: TObject);
begin
  InsertText(self, ' * ')

end;

procedure TfrmMultiplierEditor.btnDivideClick(Sender: TObject);
begin
  InsertText(self, ' / ')

end;

procedure TfrmMultiplierEditor.sgDefinedArraysDblClick(Sender: TObject);
var
  AString : string;
begin
  AString := sgDefinedArrays.Cells[0, sgDefinedArrays.Selection.Top];
  InsertText(self, AString);
end;

function TfrmMultiplierEditor.Formula: String;
var
  Index : integer;
begin
  result := '';
  for Index := 0 to memoFunction.Lines.Count -1 do
  begin
    result := result + memoFunction.Lines[Index];
  end;

end;

procedure TfrmMultiplierEditor.btnOKClick(Sender: TObject);
var
  UnrecognizedString : string;
  FormulaString : string;
  SelStart, SelLength : integer;
begin
  if not FormulaOk(UnrecognizedString, SelStart, SelLength) then
  begin
    ModalResult := mrNone;
    FormulaString := Formula;
    memoFunction.SelStart := SelStart;
    memoFunction.SelLength := SelLength;

    Beep;
    MessageDlg('The following part of your formula was not recognized. "'
      + UnrecognizedString + '"',mtError,[mbOK],0);
    memoFunction.SetFocus;
  end;
end;

function TfrmMultiplierEditor.GetFirstBreak(const FormulaString : string): integer;
var
  Index : integer;
  Position : integer;
begin
  result := 0;
  for Index := 0 to 3 do
  begin
    Position := Pos(BreakPoints[Index],FormulaString);
    if (Position > 0) and ((Position < result) or (result = 0)) then
    begin
      result := Position;
    end;
  end;
end;

function TfrmMultiplierEditor.ParameterOK(Parameter : string): boolean;
var
  Index : integer;
begin
  result := False;
  for Index := 0 to sgDefinedArrays.RowCount -1 do
  begin
    if sgDefinedArrays.Cells[0,Index] = Parameter then
    begin
      result := True;
      break;
    end;
  end;

end;

function TfrmMultiplierEditor.FormulaOk(var UnrecognizedString : string; var SelStart, SelLength : integer): boolean;
var
  FormulaString : string;
  Position : integer;
  Parameter : string;
  CharIndex : integer;
begin
  result := True;
  FormulaString := Formula;
  SelStart := 0;
  SelLength := 0;
  repeat
    Position := GetFirstBreak(FormulaString);
    if Position > 0 then
    begin
      Parameter := Trim(Copy(FormulaString,1,Position-1));
      if not ParameterOK(Parameter) then
      begin
        UnrecognizedString := Parameter;
        SelLength := Length(UnrecognizedString);
        result := False;
        for CharIndex := 1 to Length(FormulaString) do
        begin
          if FormulaString[CharIndex] = ' ' then
          begin
            Inc(SelStart);
          end
          else
          begin
            break;
          end;

        end;

        break;
      end;
      FormulaString := Copy(FormulaString, Position+1, Length(FormulaString));
      SelStart := SelStart + Position;
    end;
  until Position = 0;
  FormulaString := Trim(FormulaString);
  if result and not ParameterOK(FormulaString) then
  begin
    UnrecognizedString := FormulaString;
    result := False;
  end;
end;

function TfrmMultiplierEditor.ArgusArrayFormula(const Row : integer): string;
var
  Multiplier : double;
begin
//  with frmModflow.dgMultiplier do
//  begin
    try
      Multiplier := InternationalStrToFloat(frmModflow.dgMultiplier.Cells[3,Row])
    except on EConvertError do
      begin
        Multiplier := 1;
      end;
    end;
    if Multiplier = 1 then
    begin
      result := frmModflow.dgMultiplier.Cells[1,Row]+ ' Layer'
    end
    else
    begin
      Result := '(' + frmModflow.dgMultiplier.Cells[3,Row] + '*' + frmModflow.dgMultiplier.Cells[1,Row] + ' Layer'  + ')'
    end;
//  end;
end;

function TfrmMultiplierEditor.ConstantValue(const Row : integer): string;
var
  Multiplier : double;
begin
//  with frmModflow.dgMultiplier do
//  begin
    try
      Multiplier := InternationalStrToFloat(frmModflow.dgMultiplier.Cells[3,Row])
    except on EConvertError do
      begin
        Multiplier := 1;
      end;
    end;
    Result := InternationalFloatToStr(Multiplier);
//  end;
end;

function TfrmMultiplierEditor.FormulaValue(const Row : integer): string;
var
  ResultStringList : TStringList;
  BreakPosition : integer;
  AString : string;
  UnrecognizedString : string;
//  MultType : integer;
//  Multiplier : double;
  Index, InnerIndex : integer;
begin
//  with frmModflow.dgMultiplier do
//  begin
    UnrecognizedString := frmModflow.dgMultiplier.Cells[3,Row];
    ResultStringList := TStringList.Create;
    try
      repeat
        BreakPosition := GetFirstBreak(UnrecognizedString);
        if BreakPosition > 0 then
        begin
          AString := Trim(Copy(UnrecognizedString,1,BreakPosition-1));
          ResultStringList.Add(AString);
          ResultStringList.Add(UnrecognizedString[BreakPosition]);
          UnrecognizedString := Trim(Copy(UnrecognizedString,BreakPosition+1,
            Length(UnrecognizedString)));
        end;
      until BreakPosition = 0;
      ResultStringList.Add(UnrecognizedString);

      for Index := 0 to ResultStringList.Count -1 do
      begin
        if not Odd(Index) then
        begin  // multiplier name
          AString := ResultStringList[Index];
          for InnerIndex := 1 to Row-1 do
          begin
            if AString = Trim(frmModflow.dgMultiplier.Cells[1,InnerIndex]) then
            begin
              ResultStringList[Index] := ArgusFormula(InnerIndex);
            end;
          end;
        end;
      end;

      result := '';
      for Index := 0 to ResultStringList.Count -1 do
      begin
        if Odd(Index) then
        begin
          // operator
          result := result + ResultStringList[Index];
        end
        else
        begin
          // multiplier name
          if Index > 0 then
          begin
            result := '(' + result + ResultStringList[Index] + ')';
          end
          else
          begin
            result := ResultStringList[Index]
          end;
        end;
      end;

    finally
      ResultStringList.Free;
    end;
//  end;
end;

function TfrmMultiplierEditor.ArgusFormula(const Row : integer): string;
var
//  ResultStringList : TStringList;
//  BreakPosition : integer;
//  AString : string;
//  UnrecognizedString : string;
  MultType : integer;
//  Multiplier : double;
//  Index, InnerIndex : integer;
begin
    MultType := frmModflow.dgMultiplier.columns[2].Picklist.IndexOf
      (frmModflow.dgMultiplier.Cells[2,Row]);
    case MultType of
      0: // ArgusArray
        begin
          Result := ArgusArrayFormula(Row);
        end;
      1: // function
        begin
          result := FormulaValue(Row);
        end;
      2: // Constant
        begin
          Result := ConstantValue(Row);
        end;
    else Assert(False);
    end;


end;


function TfrmMultiplierEditor.ArgusFormula(const MultName: string): string;
var
  RowIndex : integer;
begin
  with frmModflow.dgMultiplier do
  begin
    for RowIndex := 1 to RowCount -1 do
    begin
      if Cells[1,RowIndex] = MultName then
      begin
        result := ArgusFormula(RowIndex);
        Exit;
      end;
    end;
  end;
  Assert(False);
end;

end.
