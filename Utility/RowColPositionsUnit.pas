unit RowColPositionsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, RowColumnFrameUnit, StdCtrls, Buttons, ArgusFormUnit;

type
  TfrmRowColPositions = class(TArgusForm)
    FrameColPosition: TFramePosition;
    FrameRowPosition: TFramePosition;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Splitter1: TSplitter;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject); override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRowColPositions: TfrmRowColPositions;

implementation

{$R *.DFM}

procedure TfrmRowColPositions.FormCreate(Sender: TObject);
begin
  FrameColPosition.Width := (ClientWidth - Splitter1.Width) div 2;
end;

end.

