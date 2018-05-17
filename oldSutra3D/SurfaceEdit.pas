unit SurfaceEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, RBWZoomBox, StdCtrls, AnePIE, OptionsUnit;

type
  TSurfacePoint = Class(TRBWZoomPoint)
  private
    Z : Double;
    XModified, YModified, ZModified : boolean;
    Function Select(X,Y : integer) : boolean;
    procedure Draw;
    Constructor Create(AZoomImage : TRBWZoomBox);
  end;

  TSurfaceCountour = class(TObject)
  private
    BoundaryZoomPointList : TList;
    ContourObjectOptions : TContourObjectOptions;
    Point1, Point2, Point3 : TSurfacePoint;
    Constructor Create(ModelHandle : ANE_PTR; const layerHandle : ANE_PTR;
      objectIndex : ANE_INT32);
    Procedure Draw;
    function IsInside(X, Y: ANE_DOUBLE): boolean;
    procedure SetValues(ModelHandle: ANE_PTR) ;
  public
    Destructor Destroy; override;
  end;

  TfrmSurfaceEdit = class(TForm)
    zbMain: TRBWZoomBox;
    Panel1: TPanel;
    sbZoomIn: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbZoom: TSpeedButton;
    sbZoomExtents: TSpeedButton;
    sbSelect: TSpeedButton;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure sbZoomClick(Sender: TObject);
    procedure zbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure zbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbZoomOutClick(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoomExtentsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure zbMainPaint(Sender: TObject);
  private
    ContourList : TList;
    X1Index : ANE_INT16;
    Y1Index : ANE_INT16;
    Z1Index : ANE_INT16;
    X2Index : ANE_INT16;
    Y2Index : ANE_INT16;
    Z2Index : ANE_INT16;
    X3Index : ANE_INT16;
    Y3Index : ANE_INT16;
    Z3Index : ANE_INT16;
    SelectedContour : TSurfaceCountour;
    SelectedPoint : TSurfacePoint;
    StartX, StartY : ANE_DOUBLE;
    { Private declarations }
  public
    procedure CreateContours(ModelHandle, LayerHandle: ANE_PTR);
    procedure SetContourValues(ModelHandle: ANE_PTR);
    { Public declarations }
  end;


var
  frmSurfaceEdit: TfrmSurfaceEdit;

implementation

{$R *.DFM}

uses SLGeneralParameters, PointEditUnit;

procedure TfrmSurfaceEdit.sbZoomClick(Sender: TObject);
begin
  if sbZoom.Down then
  begin
    zbMain.Cursor := crCross;
  end
  else
  begin
    zbMain.AbortZoom;
    zbMain.Cursor := crDefault;
  end;
end;

procedure TfrmSurfaceEdit.zbMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MousePoint : TRBWZoomPoint;
  XDouble, YDouble : double;
  ContourIndex : integer;
  AContour : TSurfaceCountour;
begin
  if sbZoom.Down then
  begin
    zbMain.BeginZoom(X, Y);
  end
  else if sbSelect.Down then
  begin
    if SelectedContour = nil then
    begin
      MousePoint := TRBWZoomPoint.Create(zbMain);
      try
        MousePoint.XCoord := X;
        MousePoint.YCoord := Y;
        XDouble := MousePoint.X;
        YDouble := MousePoint.Y;
      finally
        MousePoint.Free;
      end;
      for ContourIndex := 0 to ContourList.Count -1 do
      begin
        AContour := ContourList[ContourIndex];
        if AContour.IsInside(XDouble,YDouble) then
        begin
          SelectedContour := AContour;
          break;
        end;
      end;
    end
    else if SelectedPoint = nil then
    begin
      if SelectedContour.Point1.Select(X, Y) then
      begin
        SelectedPoint := SelectedContour.Point1;
        zbMainMouseDown(Sender, Button, Shift, X, Y);
      end else
      if SelectedContour.Point2.Select(X, Y) then
      begin
        SelectedPoint := SelectedContour.Point2;
        zbMainMouseDown(Sender, Button, Shift, X, Y);
      end else
      if SelectedContour.Point3.Select(X, Y) then
      begin
        SelectedPoint := SelectedContour.Point3;
        zbMainMouseDown(Sender, Button, Shift, X, Y);
      end
      else
      begin
        SelectedContour := nil;
        zbMainMouseDown(Sender, Button, Shift, X, Y);
      end;
{      if SelectedPoint <> nil then
      begin
        zbMainMouseDown(Sender, Button, Shift, X, Y);
      end;  }
    end
    else
    begin
      if SelectedPoint.Select(X, Y) then
      begin
        StartX := SelectedPoint.X;
        StartY := SelectedPoint.Y;
{        frmPointEdit := TfrmPointEdit.Create(Application);
        try
          frmPointEdit.adeX.Text := FloatToStr(SelectedPoint.X);
          frmPointEdit.adeY.Text := FloatToStr(SelectedPoint.Y);
          frmPointEdit.adeZ.Text := FloatToStr(SelectedPoint.Z);
          if frmPointEdit.ShowModal = mrOK then
          begin
            AValue := StrToFloat(frmPointEdit.adeX.Text);
            if SelectedPoint.X <> AValue then
            begin
              SelectedPoint.X := AValue;
              SelectedPoint.XModified := True;
            end;

            AValue := StrToFloat(frmPointEdit.adeY.Text);
            if SelectedPoint.Y <> AValue then
            begin
              SelectedPoint.Y := AValue;
              SelectedPoint.YModified := True;
            end;

            AValue := StrToFloat(frmPointEdit.adeZ.Text);
            if SelectedPoint.Z <> AValue then
            begin
              SelectedPoint.Z := AValue;
              SelectedPoint.ZModified := True;
            end;
          end;
        finally
          frmPointEdit.Free;
          frmPointEdit := nil;
        end;
        }

      end
      else
      begin
        SelectedPoint := nil;
        zbMainMouseDown(Sender, Button, Shift, X, Y);
      end;
    end;
    zbMain.Invalidate;
  end;
end;

procedure TfrmSurfaceEdit.zbMainMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if sbZoom.Down then
  begin
    zbMain.ContinueZoom(X, Y);
  end
  else if sbSelect.Down then
  begin
    if (SelectedContour <> nil) and (SelectedPoint <> nil) then
    begin
      SelectedPoint.XCoord := X;
      SelectedPoint.YCoord := Y;
      zbMain.Invalidate;
    end;
  end;

end;

procedure TfrmSurfaceEdit.zbMainMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MousePoint : TRBWZoomPoint;
  ContourIndex : integer;
  AContour : TSurfaceCountour;
  XDouble, YDouble, AValue : double;
begin
  if sbZoom.Down then
  begin
    zbMain.FinishZoom(X, Y);
    zbMain.Cursor := crDefault;
    zbMain.Invalidate;
    sbSelect.Down := True;
  end
  else if sbSelect.Down then
  begin
    if SelectedContour = nil then
    begin
      MousePoint := TRBWZoomPoint.Create(zbMain);
      try
        MousePoint.XCoord := X;
        MousePoint.YCoord := Y;
        XDouble := MousePoint.X;
        YDouble := MousePoint.Y;
      finally
        MousePoint.Free;
      end;
      for ContourIndex := 0 to ContourList.Count -1 do
      begin
        AContour := ContourList[ContourIndex];
        if AContour.IsInside(XDouble,YDouble) then
        begin
          SelectedContour := AContour;
          break;
        end;
      end;
    end
    else if SelectedPoint = nil then
    begin
      if SelectedContour.Point1.Select(X, Y) then
      begin
        SelectedPoint := SelectedContour.Point1;
      end else
      if SelectedContour.Point2.Select(X, Y) then
      begin
        SelectedPoint := SelectedContour.Point2;
      end else
      if SelectedContour.Point3.Select(X, Y) then
      begin
        SelectedPoint := SelectedContour.Point3;
      end
      else
      begin
        SelectedContour := nil;
        zbMainMouseUp(Sender, Button, Shift, X, Y);
      end;
      if SelectedPoint <> nil then
      begin
        zbMainMouseUp(Sender, Button, Shift, X, Y);
      end; 
    end
    else
    begin
      if SelectedPoint.Select(X, Y) then
      begin
        frmPointEdit := TfrmPointEdit.Create(Application);
        try
          frmPointEdit.adeX.Text := FloatToStr(SelectedPoint.X);
          frmPointEdit.adeY.Text := FloatToStr(SelectedPoint.Y);
          frmPointEdit.adeZ.Text := FloatToStr(SelectedPoint.Z);
          if frmPointEdit.ShowModal = mrOK then
          begin
            AValue := StrToFloat(frmPointEdit.adeX.Text);
            if (SelectedPoint.X <> AValue) or (StartX <> AValue) then
            begin
              SelectedPoint.X := AValue;
              SelectedPoint.XModified := True;
            end;

            AValue := StrToFloat(frmPointEdit.adeY.Text);
            if (SelectedPoint.Y <> AValue) or (StartY <> AValue) then
            begin
              SelectedPoint.Y := AValue;
              SelectedPoint.YModified := True;
            end;

            AValue := StrToFloat(frmPointEdit.adeZ.Text);
            if SelectedPoint.Z <> AValue then
            begin
              SelectedPoint.Z := AValue;
              SelectedPoint.ZModified := True;
            end;
          end
          else
          begin
            SelectedPoint.X := StartX;
            SelectedPoint.Y := StartY;
          end;
          SelectedPoint := nil;
        finally
          frmPointEdit.Free;
          frmPointEdit := nil;
        end;

      end
      else
      begin
        SelectedPoint := nil;
        zbMainMouseUp(Sender, Button, Shift, X, Y);
      end;
    end;
    zbMain.Invalidate;
  end;
end;

procedure TfrmSurfaceEdit.sbZoomOutClick(Sender: TObject);
var
  APoint : TRBWZoomPoint;
begin
  APoint := TRBWZoomPoint.Create(zbMain);
  try
    APoint.XCoord := zbMain.HorzScrollBar.ScrollPos + (zbMain.ClientWidth div 2);
    APoint.YCoord := zbMain.VertScrollBar.ScrollPos + (zbMain.ClientHeight div 2);
    zbMain.ZoomByAt(0.5,APoint.X, APoint.Y);
  finally
    APoint.Free;
  end;
  zbMain.Invalidate;
end;

procedure TfrmSurfaceEdit.sbZoomInClick(Sender: TObject);
var
  APoint : TRBWZoomPoint;
begin
  APoint := TRBWZoomPoint.Create(zbMain);
  try
    APoint.XCoord := zbMain.HorzScrollBar.ScrollPos + (zbMain.ClientWidth div 2);
    APoint.YCoord := zbMain.VertScrollBar.ScrollPos + (zbMain.ClientHeight div 2);
    zbMain.ZoomByAt(2,APoint.X, APoint.Y);
  finally
    APoint.Free;
  end;
  zbMain.Invalidate;
end;

procedure TfrmSurfaceEdit.sbZoomExtentsClick(Sender: TObject);
begin
  zbMain.GetMinMax;
  zbMain.ZoomOut;
  zbMain.Invalidate;
end;

procedure TfrmSurfaceEdit.FormCreate(Sender: TObject);
begin
  ContourList := TList.Create;
  SelectedContour := nil;
  SelectedPoint := nil;
end;

procedure TfrmSurfaceEdit.FormDestroy(Sender: TObject);
var
  Index : integer;
begin
  for Index := 0 to ContourList.Count -1 do
  begin
    TSurfaceCountour(ContourList[Index]).Free;
  end;
end;

procedure TfrmSurfaceEdit.CreateContours(ModelHandle,
  LayerHandle: ANE_PTR);
var
  ContourIndex, ContourCount : integer;
  LayerOptions : TLayerOptions;
  AContour : TSurfaceCountour;
begin
  LayerOptions := TLayerOptions.Create(LayerHandle);
  try
    X1Index := LayerOptions.GetParameterIndex
      (ModelHandle, TX1Param.ANE_ParamName);
    Y1Index := LayerOptions.GetParameterIndex
      (ModelHandle, TY1Param.ANE_ParamName);
    Z1Index := LayerOptions.GetParameterIndex
      (ModelHandle, TZ1Param.ANE_ParamName);
    X2Index := LayerOptions.GetParameterIndex
      (ModelHandle, TX2Param.ANE_ParamName);
    Y2Index := LayerOptions.GetParameterIndex
      (ModelHandle, TY2Param.ANE_ParamName);
    Z2Index := LayerOptions.GetParameterIndex
      (ModelHandle, TZ2Param.ANE_ParamName);
    X3Index := LayerOptions.GetParameterIndex
      (ModelHandle, TX3Param.ANE_ParamName);
    Y3Index := LayerOptions.GetParameterIndex
      (ModelHandle, TY3Param.ANE_ParamName);
    Z3Index := LayerOptions.GetParameterIndex
      (ModelHandle, TZ3Param.ANE_ParamName);

    ContourCount := LayerOptions.NumObjects(ModelHandle,pieContourObject);
    for ContourIndex := 0 to ContourCount-1 do
    begin
      AContour := TSurfaceCountour.Create(ModelHandle, LayerHandle, ContourIndex);
      ContourList.Add(AContour);
    end;
  finally
    LayerOptions.Free(ModelHandle);
  end;
end;

procedure TfrmSurfaceEdit.zbMainPaint(Sender: TObject);
var
  ContourIndex : integer;
  AContour : TSurfaceCountour;
begin
  zbMain.PBCanvas.Pen.Color := clBlack;
  for ContourIndex := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList[ContourIndex];
    AContour.Draw;
  end;
end;

{ TSurfacePoint }

constructor TSurfacePoint.Create(AZoomImage : TRBWZoomBox);
begin
  inherited;
  XModified := False;
  YModified := False;
  ZModified := False;
end;

procedure TSurfacePoint.Draw;
begin
  if self = frmSurfaceEdit.SelectedPoint then
  begin
    frmSurfaceEdit.zbMain.PBCanvas.Brush.Color := clRed;
  end
  else
  begin
    frmSurfaceEdit.zbMain.PBCanvas.Brush.Color := clBlue;
  end;
  frmSurfaceEdit.zbMain.PBCanvas.Rectangle(XCoord-3,
    YCoord-3,XCoord+3, YCoord+3);

end;

function TSurfacePoint.Select(X, Y: integer): boolean;
var
  XLoc, YLoc : integer;
begin
  XLoc := XCoord;
  YLoc := YCoord;
  result := (XLoc - 3 <= X) and (XLoc + 3 >= X)
    and (YLoc - 3 <= Y) and (YLoc + 3 >= Y)
end;

procedure TfrmSurfaceEdit.SetContourValues(ModelHandle: ANE_PTR);
var
  Index : integer;
  AContour : TSurfaceCountour;
begin
  for Index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList[Index];
    AContour.SetValues(ModelHandle);
  end;

end;

{ TSurfaceCountour }

constructor TSurfaceCountour.Create(ModelHandle: ANE_PTR;
  const layerHandle: ANE_PTR; objectIndex: ANE_INT32);
var
  NodeIndex, NodeCount : integer;
  X, Y : Double;
  APoint : TRBWZoomPoint;
begin
  BoundaryZoomPointList := TList.Create;
  Point1 := TSurfacePoint.Create(frmSurfaceEdit.zbMain);
  Point2 := TSurfacePoint.Create(frmSurfaceEdit.zbMain);
  Point3 := TSurfacePoint.Create(frmSurfaceEdit.zbMain);
  ContourObjectOptions := TContourObjectOptions.Create(ModelHandle,
    layerHandle,objectIndex);
  NodeCount := ContourObjectOptions.NumberOfNodes(ModelHandle);
  BoundaryZoomPointList.Capacity := NodeCount;
  for NodeIndex := 0 to NodeCount-1 do
  begin
    ContourObjectOptions.GetNthNodeLocation(ModelHandle, X, Y, NodeIndex);
    APoint := TRBWZoomPoint.Create(frmSurfaceEdit.zbMain);
    APoint.X := X;
    APoint.Y := Y;
    BoundaryZoomPointList.Add(APoint);
  end;
  Point1.X := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.X1Index);
  Point1.Y := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.Y1Index);
  Point1.Z := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.Z1Index);
  Point2.X := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.X2Index);
  Point2.Y := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.Y2Index);
  Point2.Z := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.Z2Index);
  Point3.X := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.X3Index);
  Point3.Y := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.Y3Index);
  Point3.Z := ContourObjectOptions.GetFloatParameter
    (ModelHandle, frmSurfaceEdit.Z3Index);

end;

destructor TSurfaceCountour.Destroy;
var
  Index : integer;
begin
  for Index := 0 to BoundaryZoomPointList.Count -1 do
  begin
    TRBWZoomPoint(BoundaryZoomPointList[Index]).Free;
  end;
  BoundaryZoomPointList.Free;
  Point1.Free;
  Point2.Free;
  Point3.Free;
  ContourObjectOptions.Free;
end;

procedure TSurfaceCountour.Draw;
var
  NodeIndex : Integer;
  AZoomPoint : TRBWZoomPoint;
  Selected : boolean;
begin
  if BoundaryZoomPointList.Count > 0 then
  begin
    AZoomPoint := BoundaryZoomPointList[0];
    frmSurfaceEdit.zbMain.PBCanvas.MoveTo(AZoomPoint.XCoord, AZoomPoint.YCoord);
  end;
  Selected := frmSurfaceEdit.SelectedContour = self;
  frmSurfaceEdit.zbMain.PBCanvas.Brush.Color := clBlack;
  for NodeIndex := 0 to BoundaryZoomPointList.Count -1 do
  begin
    AZoomPoint := BoundaryZoomPointList[NodeIndex];
    frmSurfaceEdit.zbMain.PBCanvas.LineTo(AZoomPoint.XCoord, AZoomPoint.YCoord);
    if Selected then
    begin
      frmSurfaceEdit.zbMain.PBCanvas.Rectangle(AZoomPoint.XCoord-2,
        AZoomPoint.YCoord-2,AZoomPoint.XCoord+2, AZoomPoint.YCoord+2)
    end;
  end;
  if Selected then
  begin
    Point1.Draw;
    Point2.Draw;
    Point3.Draw;
  end;
end;

function TSurfaceCountour.IsInside( X, Y: ANE_DOUBLE) : boolean;
var
  NodeIndex : integer;
  NodeX, NodeY : double;
  NextNodeX, NextNodeY : double;
  APoint, NextPoint : TRBWZoomPoint;
begin   // based on CACM 112
  result := true;
  For NodeIndex := 0 to BoundaryZoomPointList.Count -2 do
  begin
    APoint := BoundaryZoomPointList[NodeIndex];
    NodeX := APoint.X;
    NodeY := APoint.Y;
    NextPoint := BoundaryZoomPointList[NodeIndex+1];
    NextNodeX := NextPoint.X;
    NextNodeY := NextPoint.Y;
    if ((Y <= NodeY) = (Y > NextNodeY)) and
       (X - NodeX - (Y - NodeY) *
         (NextNodeX - NodeX)/
         (NextNodeY - NodeY) < 0) then
      begin
        result := not result;
      end;
  end;
  result := not result;
end;



procedure TSurfaceCountour.SetValues(ModelHandle: ANE_PTR);
var
  Ok : boolean;
begin
  Ok := True;
  if Point1.XModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.X1Index, Point1.X);
  end;
  if Point1.YModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.Y1Index, Point1.Y);
  end;
  if Point1.ZModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.Z1Index, Point1.Z);
  end;
  if Point2.XModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.X2Index, Point2.X);
  end;
  if Point2.YModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.Y2Index, Point2.Y);
  end;
  if Point2.ZModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.Z2Index, Point2.Z);
  end;
  if Point3.XModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.X3Index, Point3.X);
  end;
  if Point3.YModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.Y3Index, Point3.Y);
  end;
  if Point3.ZModified then
  begin
    Ok := Ok and ContourObjectOptions.SetFloatParameter
      (ModelHandle, frmSurfaceEdit.Z3Index, Point3.Z);
  end;
  if not OK then
  begin
    Beep;
    MessageDlg('Failed to set values', mtError, [mbOK], 0);
  end;
end;


end.
