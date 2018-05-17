unit RowColumnFrameUnit;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, Grids, DataGrid;

type
  TFramePosition = class(TFrame)
    dgPositions: TDataGrid;
    Panel1: TPanel;
    lblCount: TLabel;
    seCount: TSpinEdit;
    procedure seCountChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TFramePosition.seCountChange(Sender: TObject);
var
  Index : integer;
begin
  if seCount.Value < 0 then
  begin
    seCount.Value := 0;
  end;
  dgPositions.RowCount := seCount.Value;
  for Index := 0 to dgPositions.RowCount -1 do
  begin
    dgPositions.Cells[0,Index] := IntToStr(Index+1);
  end;
  dgPositions.FixedCols := 1;

end;

end.
