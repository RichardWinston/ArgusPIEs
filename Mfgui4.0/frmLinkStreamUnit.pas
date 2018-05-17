unit frmLinkStreamUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, Buttons, ExtCtrls, RbwZoomBox, AnePIE, contnrs,  
  QuadtreeClass, ComCtrls;

type
  TfrmLinkStreams = class(TArgusForm)
    zbStreams: TRbwZoomBox;
    Panel1: TPanel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    sbPick: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbZoom: TSpeedButton;
    sbZoomExtents: TSpeedButton;
    qtStartPoints: TRbwQuadTree;
    btnLinkStreams: TButton;
    qtSelectedStartPoints: TRbwQuadTree;
    btnHelp: TBitBtn;
    StatusBar1: TStatusBar;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure zbStreamsPaint(Sender: TObject);
    procedure zbStreamsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbPickClick(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoomOutClick(Sender: TObject);
    procedure sbZoomExtentsClick(Sender: TObject);
    procedure sbZoomClick(Sender: TObject);
    procedure zbStreamsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbStreamsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnLinkStreamsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    Contours: TObjectList;
    GroupCount: integer;
    LinkDistance: double;
    SelectCount: integer;
    LinkedStreams: TList;
    procedure ArrangeContours;
    procedure GetData;
    procedure SetData;
    procedure SelectStream(const AddToSelection: boolean; const X, Y: Integer);
    procedure StoreStartPoints;
    procedure LinkStreams(const StartPoints: TRBWQuadTree; const UseAllPoints:
      boolean);
    procedure LinkSelectedStreams;
    procedure RenumberStreams;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLinkStreams: TfrmLinkStreams;

procedure LinkStreams(aneHandle: ANE_PTR;
  const fileName: ANE_STR; layerHandle: ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses Math, Variables, ANE_LayerUnit, OptionsUnit, UtilityFunctions,
  frmStreamJoinDistanceUnit, frmStreamLinkChoiceUnit;

type
  TStreamContour = class(TContourObjectOptions)
  private
    FSegmentIndex: ANE_INT16;
    FDownstreamIndex: ANE_INT16;
    FPoints: TZBArray;
    FDownstreamSegment: ANE_INT32;
    DownstreamModified: boolean;
    FSelected: boolean;
    FDownContour: TStreamContour;
    UpContours: TList;
    FGroupNumber: integer;
    FStreamOrder: integer;
    FSegment: integer;
    procedure SetDownstreamSegment(const Value: ANE_INT32);
    procedure SetSelected(const Value: boolean);
    procedure SetGroupNumber(const Value: integer);
    procedure SetStreamOrder(const Value: integer);
    procedure SetSegment(const Value: integer);
  public
    property DownstreamSegment: ANE_INT32 read FDownstreamSegment write
      SetDownstreamSegment;
    constructor Create(ModelHandle: ANE_PTR; const layerHandle: ANE_PTR;
      objectIndex: ANE_INT32; const SegmentIndex: ANE_INT16;
      const DownstreamIndex: ANE_INT16);
    destructor Destroy; override;
    procedure Draw;
    property Selected: boolean read FSelected write SetSelected;
    property GroupNumber: integer read FGroupNumber write SetGroupNumber;
    procedure UpdateArgusOne(const SetSegmentNumber: boolean);
    property StreamOrder: integer read FStreamOrder write SetStreamOrder;
    property Segment: integer read FSegment write SetSegment;
  end;

procedure LinkStreams(aneHandle: ANE_PTR;
  const fileName: ANE_STR; layerHandle: ANE_PTR); cdecl;
begin
  if EditWindowOpen then
  begin
    // Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True;
    try // try 1
      begin
        try // try 2
          begin
            frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle)
              as ModflowTypes.GetModflowFormType;

            if not frmMODFLOW.cbSTR.Checked and not frmMODFLOW.cbSFR.Checked then
            begin
              Beep;
              MessageDlg('You must be using the Stream or SFR Package in order to '
                + 'link streams.', mtInformation, [mbOK], 0);
              Exit;
            end;

            if not ((frmMODFLOW.cbSTR.Checked and frmMODFLOW.cbStreamTrib.Checked)
              or (frmMODFLOW.cbSFR.Checked and frmMODFLOW.cbSFRTrib.Checked)) then
            begin
              Beep;
              MessageDlg('You must be using the Stream tributaries in the '
                + 'Stream Package or SFR Package in order to '
                + 'link streams.', mtInformation, [mbOK], 0);
              Exit;
            end;

            frmLinkStreams := TfrmLinkStreams.Create(nil);
            try
              frmLinkStreams.CurrentModelHandle := aneHandle;
              frmLinkStreams.GetData;
              frmLinkStreams.ShowModal;
            finally
              frmLinkStreams.Free;
            end;
          end; // try 2
        except on E: Exception do
          begin
            Beep;
            MessageDlg(E.Message, mtError, [mbOK], 0);
            // result := False;
          end;
        end // try 2
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

{ TfrmLinkStreams }

procedure TfrmLinkStreams.StoreStartPoints;
var
  ContourIndex: integer;
  Stream: TStreamContour;
begin
  qtStartPoints.XMin := zbStreams.MinX;
  qtStartPoints.XMax := zbStreams.MaxX;
  qtStartPoints.YMin := zbStreams.MinY;
  qtStartPoints.YMax := zbStreams.MaxY;

  qtSelectedStartPoints.XMin := zbStreams.MinX;
  qtSelectedStartPoints.XMax := zbStreams.MaxX;
  qtSelectedStartPoints.YMin := zbStreams.MinY;
  qtSelectedStartPoints.YMax := zbStreams.MaxY;
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    if Length(Stream.FPoints) > 0 then
    begin
      qtStartPoints.AddPoint(Stream.FPoints[0].X,
        Stream.FPoints[0].Y, Stream);
    end;
  end;
end;

procedure TfrmLinkStreams.LinkSelectedStreams;
var
  ContourIndex: integer;
  Stream: TStreamContour;
begin
  qtSelectedStartPoints.Clear;
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    if Stream.Selected and (Length(Stream.FPoints) > 0) then
    begin
      qtSelectedStartPoints.AddPoint(Stream.FPoints[0].X,
        Stream.FPoints[0].Y, Stream);
    end;
  end;
  LinkStreams(qtSelectedStartPoints, False);
end;

procedure TfrmLinkStreams.LinkStreams(const StartPoints: TRBWQuadTree;
  const UseAllPoints: boolean);
var
  ContourIndex: integer;
  Stream, OtherStream: TStreamContour;
  EndPoint, StartPoint: TRbwZoomPoint;
  Distance: double;
begin
  frmStreamJoinDistance := TfrmStreamJoinDistance.Create(nil);
  try
    frmStreamJoinDistance.adeDistance.Text := FloatToStr(LinkDistance);
    frmStreamJoinDistance.ShowModal;
    LinkDistance := StrToFloat(frmStreamJoinDistance.adeDistance.Text);
  finally
    frmStreamJoinDistance.Free;
  end;

  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    if (UseAllPoints or Stream.Selected) and (Length(Stream.FPoints) > 0) then
    begin
      EndPoint := Stream.FPoints[Length(Stream.FPoints) - 1];
      OtherStream := StartPoints.NearestPointsFirstData(EndPoint.X,
        EndPoint.Y);
      if (OtherStream <> nil) and (OtherStream <> Stream) then
      begin
        StartPoint := OtherStream.FPoints[0];
        Distance := Sqrt(Sqr(StartPoint.X - EndPoint.X) +
          Sqr(StartPoint.Y - EndPoint.Y));
        if (Distance <= LinkDistance) then
        begin
          Stream.DownstreamSegment := OtherStream.Segment;
        end;
      end;
    end;
  end;
  ArrangeContours;
end;

procedure TfrmLinkStreams.GetData;
var
  LayerIndex: integer;
  LayerName: string;
  Layer: TLayerOptions;
  ContourIndex: ANE_INT32;
  Contour: TStreamContour;
  DownstreamIndex: ANE_INT16;
  SegmentNumberIndex: ANE_INT16;
begin
  if StreamPackageChoice = spcSTR then
  begin
    for LayerIndex := 1 to frmModflow.dgGeol.RowCount - 1 do
    begin
      LayerName := ModflowTypes.GetMFStreamLayerType.ANE_LayerName
        + IntToStr(LayerIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
      try
        SegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,
          ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName);
        DownstreamIndex := Layer.GetParameterIndex(CurrentModelHandle,
          ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName);
        for ContourIndex := 0 to Layer.NumObjects(CurrentModelHandle,
          pieContourObject) - 1 do
        begin
          Contour := TStreamContour.Create(CurrentModelHandle, Layer.LayerHandle,
            ContourIndex, SegmentNumberIndex, DownstreamIndex);
          Contours.Add(Contour);
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;
  end
  else
  begin
    for LayerIndex := 1 to frmModflow.dgGeol.RowCount - 1 do
    begin
      LayerName := ModflowTypes.GetMF2KSimpleStreamLayerType.ANE_LayerName
        + IntToStr(LayerIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
      try
        SegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,
          ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName);
        DownstreamIndex := Layer.GetParameterIndex(CurrentModelHandle,
          ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName);
        for ContourIndex := 0 to Layer.NumObjects(CurrentModelHandle,
          pieContourObject) - 1 do
        begin
          Contour := TStreamContour.Create(CurrentModelHandle, Layer.LayerHandle,
            ContourIndex, SegmentNumberIndex, DownstreamIndex);
          Contours.Add(Contour);
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;

      if frmModflow.cbSFRCalcFlow.Checked then
      begin
        LayerName := ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName
          + IntToStr(LayerIndex);
        Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
        try
          SegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,
            ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName);
          DownstreamIndex := Layer.GetParameterIndex(CurrentModelHandle,
            ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName);
          for ContourIndex := 0 to Layer.NumObjects(CurrentModelHandle,
            pieContourObject) - 1 do
          begin
            Contour := TStreamContour.Create(CurrentModelHandle, Layer.LayerHandle,
              ContourIndex, SegmentNumberIndex, DownstreamIndex);
            Contours.Add(Contour);
          end;
        finally
          Layer.Free(CurrentModelHandle);
        end;

        LayerName := ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName
          + IntToStr(LayerIndex);
        Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
        try
          SegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,
            ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName);
          DownstreamIndex := Layer.GetParameterIndex(CurrentModelHandle,
            ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName);
          for ContourIndex := 0 to Layer.NumObjects(CurrentModelHandle,
            pieContourObject) - 1 do
          begin
            Contour := TStreamContour.Create(CurrentModelHandle, Layer.LayerHandle,
              ContourIndex, SegmentNumberIndex, DownstreamIndex);
            Contours.Add(Contour);
          end;
        finally
          Layer.Free(CurrentModelHandle);
        end;

        LayerName := ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName
          + IntToStr(LayerIndex);
        Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
        try
          SegmentNumberIndex := Layer.GetParameterIndex(CurrentModelHandle,
            ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName);
          DownstreamIndex := Layer.GetParameterIndex(CurrentModelHandle,
            ModflowTypes.GetMFStreamDownSegNumParamType.ANE_ParamName);
          for ContourIndex := 0 to Layer.NumObjects(CurrentModelHandle,
            pieContourObject) - 1 do
          begin
            Contour := TStreamContour.Create(CurrentModelHandle, Layer.LayerHandle,
              ContourIndex, SegmentNumberIndex, DownstreamIndex);
            Contours.Add(Contour);
          end;
        finally
          Layer.Free(CurrentModelHandle);
        end;
      end;
    end;
  end;

  ArrangeContours;
  zbStreams.ZoomOut;
  StoreStartPoints;
  LinkDistance := Min(zbStreams.MaxX - zbStreams.MinX,
    zbStreams.MaxY - zbStreams.MinY) / 100;
end;

procedure TfrmLinkStreams.btnOKClick(Sender: TObject);
begin
  inherited;
  SetData;
end;

procedure TfrmLinkStreams.SetData;
var
  ContourIndex: integer;
  Stream: TStreamContour;
  SetSegmentNumber: boolean;
begin
  SetSegmentNumber := MessageDlg('Do you wish to renumber the stream segments?',
    mtInformation,
    [mbYes, mbNo], 0) = mrYes;
  if SetSegmentNumber then
  begin
    RenumberStreams;
  end;

  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    Stream.UpdateArgusOne(SetSegmentNumber);
  end;
end;

procedure TfrmLinkStreams.FormCreate(Sender: TObject);
begin
  inherited;
  Contours := TObjectList.Create;
  LinkedStreams := TList.Create;
  SelectCount := 0;
end;

procedure TfrmLinkStreams.FormDestroy(Sender: TObject);
begin
  inherited;
  Contours.Free;
  LinkedStreams.Free;
end;

procedure TfrmLinkStreams.ArrangeContours;
var
  ContourIndex, InnerContourIndex: integer;
  Stream, OtherStream: TStreamContour;
begin
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    Stream.UpContours.Clear;
    Stream.FDownContour := nil;
    Stream.GroupNumber := 0;
  end;
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    if Stream.DownstreamSegment = 0 then
      Continue;
    for InnerContourIndex := 0 to Contours.Count - 1 do
    begin
      if InnerContourIndex = ContourIndex then
        Continue;
      OtherStream := Contours[InnerContourIndex] as TStreamContour;
      if Stream.DownstreamSegment = OtherStream.Segment then
      begin
        Stream.FDownContour := OtherStream;
        OtherStream.UpContours.Add(Stream);
        Break;
      end;
    end;
  end;
  GroupCount := 0;
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    if Stream.GroupNumber = 0 then
    begin
      Inc(GroupCount);
      Stream.GroupNumber := GroupCount;
    end;
  end;
  zbStreams.Invalidate;
end;

procedure TfrmLinkStreams.RenumberStreams;
var
  BaseNumber: integer;
  ContourIndex: integer;
  Stream, ErrorStream: TStreamContour;
begin
  BaseNumber := Round(IntPower(10, Trunc(Log10(Contours.Count)) + 1));
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    Stream.StreamOrder := 0;
  end;
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    if Stream.UpContours.Count = 0 then
    begin
      Stream.StreamOrder := 1;
    end;
  end;
  ErrorStream := nil;
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    if Stream.StreamOrder = 0 then
    begin
      Stream.StreamOrder := 1;
      ErrorStream := Stream;
    end;
  end;

  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    Stream.Segment := Stream.StreamOrder * BaseNumber + ContourIndex + 1;
  end;

  if ErrorStream <> nil then
  begin
    Beep;
    MessageDlg('Warning: The stream segment whose segment number is '
      + IntToStr(ErrorStream.Segment) + ' is part of a series of segments that '
      + 'circle back on themselves.  You should fix this before trying to '
      + 'run MODFLOW.', mtWarning, [mbOK], 0);
  end;
end;

{ TStreamContour }

constructor TStreamContour.Create(ModelHandle: ANE_PTR;
  const layerHandle: ANE_PTR; objectIndex: ANE_INT32; const SegmentIndex:
  ANE_INT16;
  const DownstreamIndex: ANE_INT16);
var
  PointIndex: ANE_INT32;
  X, Y: ANE_DOUBLE;
  ZoomPoint: TRbwZoomPoint;
begin
  inherited Create(ModelHandle, layerHandle, objectIndex);
  UpContours := TList.Create;
  FSegmentIndex := SegmentIndex;
  FDownstreamIndex := DownstreamIndex;
  DownstreamModified := False;
  Segment := GetIntegerParameter(frmLinkStreams.CurrentModelHandle,
    FSegmentIndex);
  FDownstreamSegment := GetIntegerParameter(frmLinkStreams.CurrentModelHandle,
    FDownstreamIndex);
  SetLength(FPoints, NumberOfNodes(frmLinkStreams.CurrentModelHandle));
  for PointIndex := 0 to Length(FPoints) - 1 do
  begin
    GetNthNodeLocation(frmLinkStreams.CurrentModelHandle, X, Y, PointIndex);
    ZoomPoint := TRbwZoomPoint.Create(frmLinkStreams.zbStreams);
    FPoints[PointIndex] := ZoomPoint;
    ZoomPoint.X := X;
    ZoomPoint.Y := Y;
  end;
end;

destructor TStreamContour.Destroy;
var
  PointIndex: ANE_INT32;
begin
  for PointIndex := 0 to Length(FPoints) - 1 do
  begin
    FPoints[PointIndex].Free;
  end;
  UpContours.Free;
  inherited;
end;

procedure TStreamContour.Draw;
const
  ArrowHeadLength = 8;
var
  PointIndex: integer;
  APoint, Point1, Point2: TRbwZoomPoint;
  AColor: TColor;
  ArrowHead: array[0..2] of TPoint;
  Angle: double;
  DeltaX, DeltaY: double;
  MainWidth, InnerWidth: integer;
begin
  if Length(FPoints) <= 0 then
    Exit;

  if Selected then
  begin
    MainWidth := 5;
    InnerWidth := 3;
  end
  else
  begin
    MainWidth := 3;
    InnerWidth := 1;
  end;

  if frmLinkStreams.GroupCount <= 1 then
  begin
    AColor := clBlack;
  end
  else
  begin
    AColor := FracToRainbow((GroupNumber - 1) / (frmLinkStreams.GroupCount -
      1));
  end;

  if Length(FPoints) >= 2 then
  begin
    Point1 := FPoints[Length(FPoints) - 2];
    Point2 := FPoints[Length(FPoints) - 1];

    DeltaX := Point2.X - Point1.X;
    DeltaY := Point2.Y - Point1.Y;
    if DeltaX = 0 then
    begin
      if DeltaY > 0 then
      begin
        Angle := Pi / 2;
      end
      else
      begin
        Angle := -Pi / 2;
      end;
    end
    else
    begin
      Angle := ArcTan2(DeltaY, DeltaX);
    end;

    ArrowHead[1].X := Point2.XCoord;
    ArrowHead[1].Y := Point2.YCoord;

    ArrowHead[0].X := ArrowHead[1].X - Round(ArrowHeadLength * Cos(Angle + Pi
      / 6));
    ArrowHead[0].Y := ArrowHead[1].Y + Round(ArrowHeadLength * Sin(Angle + Pi
      / 6));
    ArrowHead[2].X := ArrowHead[1].X - Round(ArrowHeadLength * Cos(Angle - Pi
      / 6));
    ArrowHead[2].Y := ArrowHead[1].Y + Round(ArrowHeadLength * Sin(Angle - Pi
      / 6));
  end;

  with frmLinkStreams.zbStreams do
  begin
    PBCanvas.Pen.Width := MainWidth;
    PBCanvas.Pen.Color := AColor;
    APoint := FPoints[0];
    PBCanvas.MoveTo(APoint.XCoord, APoint.YCoord);
    for PointIndex := 1 to Length(FPoints) - 1 do
    begin
      APoint := FPoints[PointIndex];
      PBCanvas.LineTo(APoint.XCoord, APoint.YCoord);
    end;
    if Length(FPoints) >= 2 then
    begin
      PBCanvas.Polyline(ArrowHead);
    end;

    PBCanvas.Pen.Width := InnerWidth;
    PBCanvas.Pen.Color := clBlack;
    APoint := FPoints[0];
    PBCanvas.MoveTo(APoint.XCoord, APoint.YCoord);
    for PointIndex := 1 to Length(FPoints) - 1 do
    begin
      APoint := FPoints[PointIndex];
      PBCanvas.LineTo(APoint.XCoord, APoint.YCoord);
    end;
    if Length(FPoints) >= 2 then
    begin
      PBCanvas.Polyline(ArrowHead);
    end;
  end;
end;

procedure TStreamContour.SetDownstreamSegment(const Value: ANE_INT32);
begin
  if FDownstreamSegment <> Value then
  begin
    FDownstreamSegment := Value;
    DownstreamModified := True;
  end;
end;

procedure TfrmLinkStreams.zbStreamsPaint(Sender: TObject);
var
  ContourIndex: integer;
  Stream: TStreamContour;
begin
  inherited;
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    Stream.Draw;
  end;

end;

procedure TStreamContour.SetGroupNumber(const Value: integer);
var
  Index: integer;
  OtherStream: TStreamContour;
begin
  if FGroupNumber <> Value then
  begin
    FGroupNumber := Value;
    if FGroupNumber <> 0 then
    begin
      if FDownContour <> nil then
      begin
        FDownContour.GroupNumber := Value;
      end;
      for Index := 0 to UpContours.Count - 1 do
      begin
        OtherStream := UpContours[Index];
        OtherStream.GroupNumber := Value;
      end;
    end;
  end;
end;

procedure TStreamContour.SetSegment(const Value: integer);
var
  ContourIndex: integer;
  Stream: TStreamContour;
begin
  if FSegment <> Value then
  begin
    FSegment := Value;
    for ContourIndex := 0 to UpContours.Count - 1 do
    begin
      Stream := UpContours[ContourIndex];
      Stream.DownstreamSegment := Value;
    end;
  end;
end;

procedure TStreamContour.SetSelected(const Value: boolean);
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    if FSelected then
    begin
      Inc(frmLinkStreams.SelectCount);
    end
    else
    begin
      Dec(frmLinkStreams.SelectCount);
    end;
    frmLinkStreams.zbStreams.Invalidate;
    frmLinkStreams.StatusBar1.Panels[1].Text := 'Seg. No. = '
      + IntToStr(Segment)
      + '; Down. Seg. No. = '
      + IntToStr(DownstreamSegment);
  end;
end;

procedure TfrmLinkStreams.SelectStream(const AddToSelection: boolean;
  const X, Y: Integer);
var
  ContourIndex: integer;
  Stream: TStreamContour;
  ShouldSelect: boolean;
begin
  for ContourIndex := 0 to Contours.Count - 1 do
  begin
    Stream := Contours[ContourIndex] as TStreamContour;
    ShouldSelect := zbStreams.SelectPolyLine(X, Y, Stream.FPoints);
    if AddToSelection then
    begin
      if ShouldSelect then
      begin
        Stream.Selected := not Stream.Selected;
      end;
    end
    else
    begin
      if ShouldSelect then
      begin
        Stream.Selected := True;
      end
      else
      begin
        Stream.Selected := False;
      end;
    end;
  end;
end;

procedure TfrmLinkStreams.zbStreamsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbPick.Down then
  begin
    SelectStream((ssCtrl in Shift), X, Y);
  end
  else if sbZoom.Down then
  begin
    zbStreams.FinishZoom(X, Y);
  end;
end;

procedure TfrmLinkStreams.sbPickClick(Sender: TObject);
begin
  inherited;
  if sbPick.Down then
  begin
    zbStreams.PBCursor := crArrow;
  end;
end;

procedure TfrmLinkStreams.sbZoomInClick(Sender: TObject);
begin
  inherited;
  zbStreams.ZoomBy(2);
end;

procedure TfrmLinkStreams.sbZoomOutClick(Sender: TObject);
begin
  inherited;
  zbStreams.ZoomBy(0.5);
end;

procedure TfrmLinkStreams.sbZoomExtentsClick(Sender: TObject);
begin
  inherited;
  zbStreams.ZoomOut;
end;

procedure TfrmLinkStreams.sbZoomClick(Sender: TObject);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbStreams.PBCursor := crCross;
  end;

end;

procedure TfrmLinkStreams.zbStreamsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbStreams.BeginZoom(X, Y);
  end;
end;

procedure TfrmLinkStreams.zbStreamsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbStreams.ContinueZoom(X, Y);
  end;
  StatusBar1.Panels[0].Text := '(X,Y) = (' + FloatToStr(zbStreams.X(X))
    + ', ' + FloatToStr(zbStreams.Y(Y)) + ')';
end;

procedure TfrmLinkStreams.btnLinkStreamsClick(Sender: TObject);
begin
  inherited;
  if Selectcount >= 2 then
  begin
    LinkSelectedStreams;
  end
  else
  begin
    LinkStreams(qtStartPoints, True);
  end;
end;

procedure TStreamContour.SetStreamOrder(const Value: integer);
begin
  if FStreamOrder <> Value then
  begin
    if (Value = 0) then
    begin
      FStreamOrder := Value;
    end
    else if Value > FStreamOrder then
    begin
      FStreamOrder := Value;
      if (FDownContour <> nil)
        and (frmLinkStreams.LinkedStreams.IndexOf(self) < 0) then
      begin
        frmLinkStreams.LinkedStreams.Add(self);
        FDownContour.StreamOrder := Value + 1;
        frmLinkStreams.LinkedStreams.Delete(frmLinkStreams.LinkedStreams.Count -
          1);
      end;
    end;
  end;
end;

procedure TStreamContour.UpdateArgusOne(const SetSegmentNumber: boolean);
begin
  if SetSegmentNumber then
  begin
    SetIntegerParameter(frmLinkStreams.CurrentModelHandle,
      FSegmentIndex, Segment);
  end;

  if DownstreamModified then
  begin
    SetIntegerParameter(frmLinkStreams.CurrentModelHandle,
      FDownstreamIndex, DownstreamSegment);
  end;
end;

procedure TfrmLinkStreams.FormResize(Sender: TObject);
begin
  inherited;
  StatusBar1.Panels[0].Width := StatusBar1.Width div 2;
end;

end.

