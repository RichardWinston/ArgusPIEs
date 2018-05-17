unit frmEditUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frmZoomUnit, ComCtrls, StdCtrls, Buttons, ExtCtrls, RBWZoomBox,
  PointContourUnit;

type
  TfrmEditNew = class(TfrmZoom)
    StatusBar1: TStatusBar;
    sbSelect: TSpeedButton;
    btnAbout: TButton;
    procedure zbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure zbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbMainPaint(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  private
    function Select(AnX, AY : integer) : TArgusPoint;
//    function WriteContours : string;
    { Private declarations }
  public
    CurrentPoint : TArgusPoint;
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


var
  frmEditNew: TfrmEditNew;

implementation

uses NodeUnit, frmAboutUnit;

{$R *.DFM}

{ TLocalPoint }

procedure TLocalPoint.Draw;
const
  size = 2;
var
  AColor : TColor;
begin
  AColor := frmEditNew.zbMain.PBCanvas.Brush.Color;
  if self <> frmEditNew.CurrentPoint then
  begin
    frmEditNew.zbMain.PBCanvas.Brush.Color := clBlack;
  end
  else
  begin
    frmEditNew.zbMain.PBCanvas.Brush.Color := clWhite;
  end;
  frmEditNew.zbMain.PBCanvas.Rectangle(XCoord-size,YCoord-size,XCoord+size,YCoord+size);
  frmEditNew.zbMain.PBCanvas.Brush.Color := AColor;
end;

class function TLocalPoint.GetZoomBox: TRBWZoomBox;
begin
  result := frmEditNew.zbMain;
end;

{ TfrmEditNew }

procedure TfrmEditNew.ReverseContours;
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

function TfrmEditNew.Select(AnX, AY: integer): TArgusPoint;
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

{function TfrmEditNew.WriteContours: string;
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
end;  }

procedure TfrmEditNew.zbMainMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  StatusBar1.Panels[0].Text :=
  {Label1.Caption :=} 'X: ' +FloatToStrF(zbMain.X(X), ffNumber, 7, 4);
  StatusBar1.Panels[1].Text :=
  {Label2.Caption :=} 'Y: ' +FloatToStrF(zbMain.Y(Y), ffNumber, 7, 4);

end;

procedure TfrmEditNew.zbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbSelect.Down then
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

procedure TfrmEditNew.zbMainPaint(Sender: TObject);
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
    frmEditNew.zbMain.PBCanvas.MoveTo(FirstPoint.XCoord,FirstPoint.YCoord);
    FirstPoint.Draw;
    For Index := 1 to FPoints.Count -1 do
    begin
      APoint := PointValues[Index];
      frmEditNew.zbMain.PBCanvas.LineTo(APoint.XCoord,APoint.YCoord);
      APoint.Draw;
    end;
  end;
end;

procedure TfrmEditNew.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

end.
