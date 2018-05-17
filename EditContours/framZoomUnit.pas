unit framZoomUnit;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, RBWZoomBox, ExtCtrls;

type
  TframZoom = class(TFrame)
    pnlBottom: TPanel;
    ZoomBox: TRBWZoomBox;
    sbZoomExtents: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbZoom: TSpeedButton;
    sbPan: TSpeedButton;
    procedure sbZoomExtentsClick(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoomOutClick(Sender: TObject);
    procedure sbZoomClick(Sender: TObject);
    procedure sbPanClick(Sender: TObject);
    procedure ZoomBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ZoomBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ZoomBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TframZoom.sbZoomExtentsClick(Sender: TObject);
begin
  ZoomBox.ZoomOut;
  sbPan.Down := False;
  sbPan.Enabled := False;
  ZoomBox.PBCursor := crDefault;
  ZoomBox.Cursor := crDefault;
  ZoomBox.SCursor := crDefault;
  sbZoomExtents.Enabled := False;
end;

procedure TframZoom.sbZoomInClick(Sender: TObject);
begin
  ZoomBox.ZoomBy(2);
  sbZoomExtents.Enabled := True;
  sbPan.Enabled := True;
end;

procedure TframZoom.sbZoomOutClick(Sender: TObject);
begin
  ZoomBox.ZoomBy(0.5);
end;

procedure TframZoom.sbZoomClick(Sender: TObject);
begin
  if sbZoom.Down then
  begin
    ZoomBox.PBCursor := crCross;
    ZoomBox.Cursor := crCross;
    ZoomBox.SCursor := crCross;
  end
  else
  begin
    ZoomBox.PBCursor := crDefault;
    ZoomBox.Cursor := crDefault;
    ZoomBox.SCursor := crDefault;
  end;
end;

procedure TframZoom.sbPanClick(Sender: TObject);
begin
  if sbPan.Down then
  begin
    ZoomBox.PBCursor := crHandPoint;
    ZoomBox.Cursor := crHandPoint;
    ZoomBox.SCursor := crHandPoint;
  end
  else
  begin
    ZoomBox.PBCursor := crDefault;
    ZoomBox.Cursor := crDefault;
    ZoomBox.SCursor := crDefault;
  end;
end;

procedure TframZoom.ZoomBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if sbZoom.Down then
  begin
    ZoomBox.BeginZoom( X, Y);
  end
  else if sbPan.Down then
  begin
    ZoomBox.BeginPan
  end;
end;

procedure TframZoom.ZoomBoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if sbZoom.Down then
  begin
    ZoomBox.ContinueZoom(X,Y);
  end;
end;

procedure TframZoom.ZoomBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if sbZoom.Down then
  begin
    ZoomBox.FinishZoom(X,Y);
    sbZoomExtents.Enabled := True;
    sbPan.Enabled := True;
  end
  else if sbPan.Down then
  begin
    ZoomBox.EndPan;
  end;

end;

end.
