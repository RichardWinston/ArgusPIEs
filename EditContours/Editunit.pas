unit EditUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Clipbrd, ExtCtrls, Buttons, ArgusDataEntry, 
  WriteContourUnit, PointContourUnit, RBWZoomBox, frmZoomUnit ;

type

  TfrmEditContours = class(TfrmZoom)
    Panel1: TPanel;
    btnOK1: TBitBtn;
    btnCancel1: TBitBtn;
    btnZoomIn: TSpeedButton;
    btnZoomOut: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    zbMain1: TRBWZoomBox;
    sbPan1: TSpeedButton;
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure zbMain1Paint(Sender: TObject);
    procedure zbMain1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbMain1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure zbMain1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbPan1Click(Sender: TObject);
  private
    { Private declarations }
  public
    CurrentPoint : TArgusPoint;
    function WriteContours : string;
//    procedure GetMinMax;
    function Select(AnX, AY : integer) : TArgusPoint;
    procedure ReverseContours;
    { Public declarations }
  end;

  TLocalPoint = class(TArgusPoint)
    procedure Draw; override;
    class Function GetZoomBox : TRBWZoomBox; override;
  end;

  TLocalContour = class(TContour)
    Procedure Draw; override;
  end;

const
  Margin = 20;

{var
  frmEditContours : TfrmEditContours;}

implementation

{$R *.DFM}

uses ANECB, NodeUnit, UtilityFunctions;


function TfrmEditContours.Select(AnX, AY: integer): TArgusPoint;
var
  index : integer;
  AContour : TContour;
  APoint : TArgusPoint;
begin
  result := nil;
  for Index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList[Index];
    APoint := AContour.Select(AnX, AY);
    if APoint <> nil then
    begin
      result := APoint;
    end;
  end;
end;

function TfrmEditContours.WriteContours: string;
var
  ContourStringList : TStringList;
  Index : integer;
  AContour : TContour;
  InnerIndex : integer;
begin
  ContourStringList := TStringList.Create;
  ContourStringList.Text := '';
  For index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList.Items[index];
    AContour.PointsToStrings;
    AContour.PointStrings.Add('');
    for InnerIndex := 0 to AContour.Heading.Count -1 do
    begin
        ContourStringList.Add(AContour.Heading[InnerIndex]);
    end;
    for InnerIndex := 0 to AContour.PointStrings.Count -1 do
    begin
      ContourStringList.Add(AContour.PointStrings[InnerIndex]);
    end;

  end;

  result := '';
  For index := 0 to ContourStringList.Count -1 do
  begin
    result := result + ContourStringList.strings[index] + Chr(10);
  end;

  result := result + Chr(10);

  ContourStringList.Free;

end;

procedure TfrmEditContours.btnZoomInClick(Sender: TObject);
begin
  if btnZoomIn.Down then
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

procedure TfrmEditContours.btnZoomOutClick(Sender: TObject);
begin
  zbMain.ZoomOut;
  sbPan.Down := False;
  sbPan.Enabled := False;
  zbMain.PBCursor := crDefault;
  zbMain.Cursor := crDefault;
  zbMain.SCursor := crDefault;
end;

procedure TfrmEditContours.FormResize(Sender: TObject);
begin
  zbMain.Invalidate;

end;

procedure TfrmEditContours.ReverseContours;
var
  ContourIndex,PointIndex : Integer;
  AContour : TContour;
begin
  for ContourIndex := 0 to Contourlist.Count -1 do
  begin
    AContour := Contourlist[ContourIndex];
    for PointIndex := 0 to Round((AContour.PointCount-2)/2) do
    begin
      AContour.ExchangePoints(PointIndex, AContour.PointCount-PointIndex-1);
    end;
  end;

end;

{ TLocalContour }

procedure TLocalContour.Draw;
var
  APoint, FirstPoint : TArgusPoint;
  Index : integer;
begin
  if not PointsReady then
  begin
    StringsToPoints;
  end;
  if FPoints.Count > 0 then
  begin
    FirstPoint := PointValues[0];
//    frmEditContours.zbMain.PBCanvas.MoveTo(FirstPoint.XCoord,FirstPoint.YCoord);
    FirstPoint.Draw;
    For Index := 1 to FPoints.Count -1 do
    begin
      APoint := PointValues[Index];
//      frmEditContours.zbMain.PBCanvas.LineTo(APoint.XCoord,APoint.YCoord);
      APoint.Draw;
    end;
  end;
end;

{ TLocalPoint }

procedure TLocalPoint.Draw;
const
  size = 2;
var
  AColor : TColor;
begin
  AColor := frmEditContours.zbMain.PBCanvas.Brush.Color;
  if self <> frmEditContours.CurrentPoint then
  begin
    frmEditContours.zbMain.PBCanvas.Brush.Color := clBlack;
  end
  else
  begin
    frmEditContours.zbMain.PBCanvas.Brush.Color := clWhite;
  end;
  frmEditContours.zbMain.PBCanvas.Rectangle(XCoord-size,YCoord-size,XCoord+size,YCoord+size);
  frmEditContours.zbMain.PBCanvas.Brush.Color := AColor;
end;

class function TLocalPoint.GetZoomBox: TRBWZoomBox;
begin
  result := frmEditContours.zbMain;
end;

procedure TfrmEditContours.zbMain1Paint(Sender: TObject);
var
  Index : integer;
  AContour : TContour;
begin
  inherited;
  for Index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList[Index];
    AContour.Draw;
  end;
end;

procedure TfrmEditContours.zbMain1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if btnZoomIn.Down then
  begin
    zbMain.BeginZoom(X, Y);
  end
  else if sbPan.Down then
  begin
    zbMain.BeginPan;
  end;
end;

procedure TfrmEditContours.zbMain1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  Label1.Caption := 'X: ' +FloatToStrF(zbMain.X(X), ffNumber, 7, 4);
  Label2.Caption := 'Y: ' +FloatToStrF(zbMain.Y(Y), ffNumber, 7, 4);
  
  if btnZoomIn.Down then
  begin
    zbMain.ContinueZoom(X, Y);
  end;

end;

procedure TfrmEditContours.zbMain1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if btnZoomIn.Down then
  begin
    zbMain.FinishZoom(X, Y);
    btnZoomIn.Down := False;
    sbPan.Enabled := True;
    zbMain.PBCursor := crDefault;
    zbMain.Cursor := crDefault;
    zbMain.SCursor := crDefault;
  end
  else if sbPan.Down then
  begin
    zbMain.EndPan;
  end
  else
  begin
    CurrentPoint := Select(X, Y);
    zbMain.Invalidate;
    if CurrentPoint <> nil then
    begin
      frmNodePosition := TfrmNodePosition.Create(self);
      try
        begin
          frmNodePosition.adeX.Text := FloatToStr(CurrentPoint.X);
          frmNodePosition.adeY.Text := FloatToStr(CurrentPoint.Y);
          frmNodePosition.ShowModal;
        end
      finally
        begin
          frmNodePosition.Free;
        end;
      end;
    end;
  end;
end;

procedure TfrmEditContours.sbPan1Click(Sender: TObject);
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

end.
