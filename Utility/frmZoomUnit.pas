unit frmZoomUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WriteContourUnit, StdCtrls, Buttons, ExtCtrls, RBWZoomBox;

type
  TfrmZoom = class(TfrmWriteContour)
    zbMain: TRBWZoomBox;
    pnlBottom: TPanel;
    sbZoomExtents: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbZoom: TSpeedButton;
    sbPan: TSpeedButton;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    BitBtn1: TBitBtn;
    procedure zbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure zbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbZoomExtentsClick(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoomOutClick(Sender: TObject);
    procedure sbZoomClick(Sender: TObject);
    procedure sbPanClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  frmZoom: TfrmZoom;   }

implementation

{$R *.DFM}

procedure TfrmZoom.zbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbMain.BeginZoom( X, Y);
  end
  else if sbPan.Down then
  begin
    zbMain.BeginPan
  end; 

end;

procedure TfrmZoom.zbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbMain.ContinueZoom(X,Y);
  end; 

end;

procedure TfrmZoom.zbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbMain.FinishZoom(X,Y);
    sbZoomExtents.Enabled := True;
    sbPan.Enabled := True;
  end
  else if sbPan.Down then
  begin
    zbMain.EndPan;
  end;

end;

procedure TfrmZoom.sbZoomExtentsClick(Sender: TObject);
begin
  inherited;
  zbMain.ZoomOut;
  sbPan.Down := False;
  sbPan.Enabled := False;
  zbMain.PBCursor := crDefault;
  zbMain.Cursor := crDefault;
  zbMain.SCursor := crDefault;
  sbZoomExtents.Enabled := False;
end;

procedure TfrmZoom.sbZoomInClick(Sender: TObject);
begin
  inherited;
  zbMain.ZoomBy(2);
  sbZoomExtents.Enabled := True;
  sbPan.Enabled := True;
end;

procedure TfrmZoom.sbZoomOutClick(Sender: TObject);
begin
  inherited;
  zbMain.ZoomBy(0.5);
end;

procedure TfrmZoom.sbZoomClick(Sender: TObject);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbMain.PBCursor := crCross;
    zbMain.Cursor := crCross;
    zbMain.SCursor := crCross;
  end
  else
  begin
    zbMain.PBCursor := crDefault;
    zbMain.Cursor := crDefault;
    zbMain.SCursor := crDefault;
  end;
end;

procedure TfrmZoom.sbPanClick(Sender: TObject);
begin
  inherited;
  if sbPan.Down then
  begin
    zbMain.PBCursor := crHandPoint;
    zbMain.Cursor := crHandPoint;
    zbMain.SCursor := crHandPoint;
  end
  else
  begin
    zbMain.PBCursor := crDefault;
    zbMain.Cursor := crDefault;
    zbMain.SCursor := crDefault;
  end;

end;

procedure TfrmZoom.FormResize(Sender: TObject);
begin
  inherited;
  zbMain.Invalidate;
end;

end.
