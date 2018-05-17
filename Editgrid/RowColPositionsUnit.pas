unit RowColPositionsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, RowColumnFrameUnit, StdCtrls, Buttons;

type
  TfrmRowColPositions = class(TForm)
    FrameColPosition: TFramePosition;
    FrameRowPosition: TFramePosition;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Splitter1: TSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRowColPositions: TfrmRowColPositions;

implementation

{$R *.DFM}

end.
