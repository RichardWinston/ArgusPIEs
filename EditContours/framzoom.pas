unit framZoom;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, RBWZoomBox, ExtCtrls;

type
  TFrame1 = class(TFrame)
    pnlBottom: TPanel;
    ZoomBox: TRBWZoomBox;
    sbZoomExtents: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbZoom: TSpeedButton;
    sbPan: TSpeedButton;
    procedure sbZoomExtentsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TFrame1.sbZoomExtentsClick(Sender: TObject);
begin
  ZoomBox.ZoomOut;
  sbPan.Down := False;
  sbPan.Enabled := False;
  ZoomBox.PBCursor := crDefault;
  ZoomBox.Cursor := crDefault;
  ZoomBox.SCursor := crDefault;
  sbZoomExtents.Enabled := False;
end;

end.
