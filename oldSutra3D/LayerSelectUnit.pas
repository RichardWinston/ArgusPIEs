unit LayerSelectUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TfrmLayerSelect = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ScrollBox1: TScrollBox;
    rgLayers: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetHeight;
  end;

var
  frmLayerSelect: TfrmLayerSelect;

implementation

{$R *.DFM}

{ TfrmLayerSelect }

procedure TfrmLayerSelect.SetHeight;
begin
  rgLayers.Height := rgLayers.Items.Count * 22;
end;

end.
