unit RowColumnFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, Grids, DataGrid, ArgusDataEntry;

type
  TFramePosition = class(TFrame)
    dgPositions: TDataGrid;
    Panel1: TPanel;
    lblCount: TLabel;
    seCount: TSpinEdit;
    Button1: TButton;
    adeMultiplier: TArgusDataEntry;
    Label1: TLabel;
    procedure seCountChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses Clipbrd;

procedure TFramePosition.seCountChange(Sender: TObject);
var
  Index: integer;
begin
  if seCount.Value < 0 then
  begin
    seCount.Value := 0;
  end;
  dgPositions.RowCount := seCount.Value;
  for Index := 0 to dgPositions.RowCount - 1 do
  begin
    dgPositions.Cells[0, Index] := IntToStr(Index + 1);
  end;
  dgPositions.FixedCols := 1;

end;

procedure TFramePosition.Button1Click(Sender: TObject);
const
  Separators = [' ', ',', #9];
var
  Values: TStringList;
  NewValues: TStringList;
  Index: integer;
  ALine: string;
  FirstIndex: integer;
  CharIndex: integer;
  NewWord: string;
  V: double;
  Code: integer;
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    Values := TStringList.Create;
    NewValues := TStringList.Create;
    try
      Values.Text := Clipboard.AsText;
      for Index := 0 to Values.Count - 1 do
      begin
        ALine := Trim(Values[Index]);
        FirstIndex := 0;
        for CharIndex := 1 to Length(ALine) do
        begin
          if (ALine[CharIndex] in Separators) or (CharIndex = Length(ALine))
            then
          begin
            NewWord := Trim(Copy(ALine, FirstIndex + 1, CharIndex -
              FirstIndex));
            FirstIndex := CharIndex;
            if NewWord <> '' then
            begin
              Val(NewWord, V, Code);
              if Code = 0 then
              begin
                NewValues.Add(NewWord);
              end;
            end;
          end;
        end;
      end;
      seCount.Value := NewValues.Count;
      for Index := 0 to NewValues.Count - 1 do
      begin
        dgPositions.Cells[1, Index] := NewValues[Index];
      end;
    finally
      Values.Free;
      NewValues.Free;
    end;
  end;
end;

end.

