unit MeshToContour;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WriteContourUnit, ExtCtrls, RBWZoomBox, contnrs,  AnePIE, Buttons,
  StdCtrls, frmZoomUnit;

type
  TfrmMeshToContour = class(TfrmZoom)
    timerLasso: TTimer;
    sbLasso: TSpeedButton;
    sbSelect: TSpeedButton;
    btnAbout: TButton;
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure zbMainPaint(Sender: TObject);
    procedure zbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure timerLassoTimer(Sender: TObject);
    procedure zbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  private
    ShiftDown : boolean;
    NodeList : TObjectList;
    SegmentList : TObjectList;
    SegmentToContours : TObjectList;
    Lasso : TObjectList;
    CurrentX, CurrentY : integer;
    PreviousX, PreviousY : integer;
    procedure Select(const X, Y: Integer);
    procedure DeselectAll;
    procedure AddLassoPoint(const X, Y: Integer);
    function PointInsideLasso(X, Y: extended): boolean;
    procedure SelectWithLasso;
    { Private declarations }
  public
    procedure ReadMesh(const LayerName : string);
    procedure ReadElements(const LayerName : string);
    { Public declarations }
  end;

procedure GMeshToContoursPIE(aneHandle : ANE_PTR;
  const  fileName : ANE_STR; layerHandle : ANE_PTR); cdecl;

procedure GElementsToContoursPIE(aneHandle : ANE_PTR;
  const  fileName : ANE_STR; layerHandle : ANE_PTR); cdecl;
  
var
  frmMeshToContour: TfrmMeshToContour;
const  
  SelectionWidth = 6;

implementation

uses OptionsUnit,ChooseLayerUnit, PointContourUnit, ANECB, frmAboutUnit,
  CheckVersionFunction;

{$R *.DFM}

type
  TElementNode = class(TArgusPoint)
    Procedure Draw; override;
    class Function GetZoomBox : TRBWZoomBox; override;
  end;

  TElementContour = class(TContour)
    Procedure Draw; override;
  end;

procedure GMeshToContoursPIE(aneHandle : ANE_PTR;
  const  fileName : ANE_STR; layerHandle : ANE_PTR); cdecl;
var
  Project : TProjectOptions;
  MeshLayerName, InfoLayerName : string;
  ImportText : string;
  AString : ANE_STR;
  Layer : TLayerOptions;
  LayerType : TPIELayerType;
begin
  MeshLayerName := '';
  InfoLayerName := '';
  Application.CreateForm(TfrmChooseLayer,frmChooseLayer);
  try
    Project := TProjectOptions.Create;
    try
      Project.LayerNames(aneHandle,[pieTriMeshLayer,pieQuadMeshLayer],
        frmChooseLayer.comboLayerNames.Items);
      if frmChooseLayer.comboLayerNames.Items.Count = 0 then
      begin
        MessageDlg('There are no mesh layers in this project.', mtInformation,
          [mbOK], 0);
        Exit;
      end;

      frmChooseLayer.cbNewLayer.Enabled := False;
      frmChooseLayer.lblChoose.Caption := 'Choose a mesh layer';
      if frmChooseLayer.ShowModal = mrOK then
      begin
        MeshLayerName:= frmChooseLayer.comboLayerNames.Text;
      end;
      if MeshLayerName <> '' then
      begin
        frmChooseLayer.comboLayerNames.Items.Clear;
        Project.LayerNames(aneHandle,[pieInformationLayer,
          pieMapsLayer,pieDomainLayer], frmChooseLayer.comboLayerNames.Items);
        frmChooseLayer.lblChoose.Width := 189;
        frmChooseLayer.lblChoose.Caption := 'Choose an information, domain outline, or maps layer';
        if frmChooseLayer.comboLayerNames.Items.Count = 0 then
        begin
          MessageDlg('There are no information, domain outline, or maps layers in this project.', mtInformation,
            [mbOK], 0);
          Exit;
        end;

        if frmChooseLayer.ShowModal = mrOK then
        begin
          InfoLayerName:= frmChooseLayer.comboLayerNames.Text;
          layerHandle := Project.GetLayerByName(aneHandle,InfoLayerName);
        end;
      end;
    finally
      Project.Free;
    end;
  finally
    frmChooseLayer.Free;
  end;
  if (MeshLayerName <> '') and (InfoLayerName <> '') then
  begin
    Application.CreateForm(TfrmMeshToContour,frmMeshToContour);
    frmMeshToContour.CurrentModelHandle := aneHandle;
    try
      frmMeshToContour.ReadMesh(MeshLayerName);
      frmMeshToContour.zbMain.ZoomOut;
      if frmMeshToContour.ShowModal = mrOK then
      begin
        Layer := TLayerOptions.Create(layerHandle);
        try
          LayerType := Layer.LayerType[aneHandle];
          if (LayerType <> pieDomainLayer) and (LayerType <> pieMapsLayer) and
            (MessageDlg('Do you want to turn on "Allow Intersection" in '
            + 'the layer into which you are importing the contours?',
            mtInformation, [mbYes, mbNo], 0) = mrYes) then
          begin
              Layer.AllowIntersection[aneHandle] := True;
          end;
        finally
          Layer.Free(aneHandle);
        end;

        ImportText := frmMeshToContour.WriteContours;

        GetMem(AString, Length(ImportText) + 1);
        try
          StrPCopy(AString, ImportText);
          ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, AString);
        finally
          FreeMem(AString);
        end;
      end;
    finally
      frmMeshToContour.Free;
    end;
  end;
end;

procedure GElementsToContoursPIE(aneHandle : ANE_PTR;
  const  fileName : ANE_STR; layerHandle : ANE_PTR); cdecl;
var
  Project : TProjectOptions;
  MeshLayerName, InfoLayerName : string;
  ImportText : string;
  AString : ANE_STR;
  Layer : TLayerOptions;
  LayerType : TPIELayerType;
begin
  MeshLayerName := '';
  InfoLayerName := '';
  Application.CreateForm(TfrmChooseLayer,frmChooseLayer);
  try
    Project := TProjectOptions.Create;
    try
      Project.LayerNames(aneHandle,[pieTriMeshLayer,pieQuadMeshLayer],
        frmChooseLayer.comboLayerNames.Items);
      if frmChooseLayer.comboLayerNames.Items.Count = 0 then
      begin
        MessageDlg('There are no mesh layers in this project.', mtInformation,
          [mbOK], 0);
        Exit;
      end;

      frmChooseLayer.cbNewLayer.Enabled := False;
      frmChooseLayer.lblChoose.Caption := 'Choose a mesh layer';
      if frmChooseLayer.ShowModal = mrOK then
      begin
        MeshLayerName:= frmChooseLayer.comboLayerNames.Text;
      end;
      if MeshLayerName <> '' then
      begin
        frmChooseLayer.comboLayerNames.Items.Clear;
        Project.LayerNames(aneHandle,[pieInformationLayer,
          pieMapsLayer,pieDomainLayer], frmChooseLayer.comboLayerNames.Items);
        frmChooseLayer.lblChoose.Width := 189;
        frmChooseLayer.lblChoose.Caption := 'Choose an information, domain outline, or maps layer';
        if frmChooseLayer.comboLayerNames.Items.Count = 0 then
        begin
          MessageDlg('There are no information, domain outline, or maps layers in this project.', mtInformation,
            [mbOK], 0);
          Exit;
        end;

        if frmChooseLayer.ShowModal = mrOK then
        begin
          InfoLayerName:= frmChooseLayer.comboLayerNames.Text;
          layerHandle := Project.GetLayerByName(aneHandle,InfoLayerName);
        end;
      end;
    finally
      Project.Free;
    end;
  finally
    frmChooseLayer.Free;
  end;
  if (MeshLayerName <> '') and (InfoLayerName <> '') then
  begin
    Application.CreateForm(TfrmMeshToContour,frmMeshToContour);
    frmMeshToContour.CurrentModelHandle := aneHandle;
    try
{      if MessageDlg('Do you want to turn on "Allow Intersection" in '
        + 'the layer into which you are importing the contours?',
        mtInformation, [mbYes, mbNo], 0) = mrYes then
      begin  }
        Layer := TLayerOptions.Create(layerHandle);
        try
          LayerType := Layer.LayerType[aneHandle];
          if (LayerType <> pieDomainLayer) and (LayerType <> pieMapsLayer) then
          begin
            Layer.AllowIntersection[aneHandle] := True;
          end;
        finally
          Layer.Free(aneHandle);
        end;
//      end;
      frmMeshToContour.ReadElements(MeshLayerName);
      ImportText := frmMeshToContour.WriteContours;

      GetMem(AString, Length(ImportText) + 1);
      try
        StrPCopy(AString, ImportText);
        ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, AString);
      finally
        FreeMem(AString);
      end;
    finally
      frmMeshToContour.Free;
    end;
  end;
end;

type
  TNode = class(TArgusPoint)
  private
    FSelected: boolean;
    procedure SetSelected(const Value: boolean);
  published
    SegmentList : TList;
    constructor Create; override;
    Destructor Destroy; override;
    Procedure Draw; override;
    property Selected : boolean read FSelected write SetSelected;
    function Select(const AnX, AY : integer) : boolean; override;
    class Function GetZoomBox : TRBWZoomBox; override;
  end;

  TSegment = class(TObject)
  private
    FSelected: boolean;
    Node1, Node2 : TNode;
    function OtherNode(const ANode : TNode) : TNode;
    procedure SetSelected(const Value: boolean);
    Procedure Draw;
    property Selected : boolean read FSelected write SetSelected;
    function Select(const X, Y : integer) : boolean;
  end;

  TContourSegmentList = class(TList)
    FirstNode : TNode;
  end;

{ TfrmMeshToContour }

procedure TfrmMeshToContour.ReadMesh(const LayerName : string);
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion : String;
  OK_Version: boolean;
  QuadLayer : TLayerOptions;
  Index : ANE_INT32;
  NodeOptions : TNodeObjectOptions;
  Node : TNode;
  ElementOptions : TElementObjectOptions;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
  X, Y : ANE_DOUBLE;
  Limit : integer;
  tempNodeList : TList;
  procedure MakeSegment(Node1, Node2 : TNode);
  var
    SegmentIndex : integer;
    ASegment : TSegment;
  begin
    for SegmentIndex := 0 to SegmentList.Count -1 do
    begin
      ASegment := SegmentList[SegmentIndex] as TSegment;
      if ((ASegment.Node1 = Node1) and (ASegment.Node2 = Node2))
        or ((ASegment.Node2 = Node1) and (ASegment.Node1 = Node2)) then
      begin
        Exit;
      end;
    end;
    ASegment := TSegment.Create;
    ASegment.Node1 := Node1;
    ASegment.Node2 := Node2;
    SegmentList.Add(ASegment);
    Node1.SegmentList.Add(ASegment);
    Node2.SegmentList.Add(ASegment);
  end;
begin
  QuadLayer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
  try
    OK_Version := CheckArgusVersion(CurrentModelHandle, MajorVersion,
        MinorVersion, Update, version, ArgusVersion);
    if OK_Version then
    begin
      zbMain.VerticalExaggeration := QuadLayer.CoordXYRatio[CurrentModelHandle];
      zbMain.XPositive := QuadLayer.CoordXRight[CurrentModelHandle];
      zbMain.YPositive := QuadLayer.CoordYUp[CurrentModelHandle];
    end;
    NodeList.Capacity := QuadLayer.NumObjects(CurrentModelHandle,
      pieNodeObject);
    for Index := 0 to NodeList.Capacity  -1 do
    begin
      NodeOptions := TNodeObjectOptions.Create(CurrentModelHandle,
        QuadLayer.LayerHandle, Index);
      try
        Node := TNode.Create;
        try
          NodeOptions.GetLocation(CurrentModelHandle, X, Y);
          Node.X := X;
          Node.Y := Y;
          NodeList.Add(Node);
        except
          Node.Free;
          raise;
        end;
      finally
        NodeOptions.Free;
      end;
    end;
    tempNodeList := TList.Create;
    try
      Limit := QuadLayer.NumObjects(CurrentModelHandle,
        pieElementObject);
      SegmentList.Capacity := Limit * 4;
      for Index := 0 to Limit -1 do
      begin
        ElementOptions := TElementObjectOptions.Create(CurrentModelHandle,
          QuadLayer.LayerHandle, Index);
        try
          tempNodeList.Clear;
          for NodeIndex := 0 to ElementOptions.NumberOfNodes
            (CurrentModelHandle) -1 do
          begin
            NodeNumber := ElementOptions.GetNthNodeNumber(CurrentModelHandle,
              NodeIndex) -1;
            Node := NodeList[NodeNumber] as TNode;
            tempNodeList.Add(Node);
          end;
          for NodeIndex := 0 to tempNodeList.Count -2 do
          begin
            MakeSegment(tempNodeList[NodeIndex], tempNodeList[NodeIndex+1]);
          end;
          if tempNodeList.Count >= 2 then
          begin
            MakeSegment(tempNodeList[0], tempNodeList[tempNodeList.Count-1]);
          end;
        finally
          ElementOptions.Free;
        end;
      end;
    finally
      tempNodeList.Free;
    end;
  finally
    QuadLayer.Free(CurrentModelHandle);
  end;

end;

procedure TfrmMeshToContour.FormCreate(Sender: TObject);
begin
  inherited;
  NodeList := TObjectList.Create;
  SegmentList := TObjectList.Create;
  Lasso := TObjectList.Create;
  SegmentToContours := TObjectList.Create;
end;

procedure TfrmMeshToContour.FormDestroy(Sender: TObject);
begin
  inherited;
  NodeList.Free;
  SegmentList.Free;
  Lasso.Free;
  SegmentToContours.Free;
end;

procedure TfrmMeshToContour.ReadElements(const LayerName: string);
var
  QuadLayer : TLayerOptions;
  Index : ANE_INT32;
  NodeOptions : TNodeObjectOptions;
  Node : TNode;
  ElementOptions : TElementObjectOptions;
  NodeIndex : ANE_INT32;
  NodeNumber : integer;
  X, Y : ANE_DOUBLE;
  Limit : integer;
  AContour : TElementContour;
  ElementNode : TElementNode;
  ProjectOptions : TProjectOptions;
  Separator : char;
begin
  QuadLayer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
  try
    NodeList.Capacity := QuadLayer.NumObjects(CurrentModelHandle,
      pieNodeObject);
    for Index := 0 to NodeList.Capacity  -1 do
    begin
      NodeOptions := TNodeObjectOptions.Create(CurrentModelHandle,
        QuadLayer.LayerHandle, Index);
      try
        Node := TNode.Create;
        try
          NodeOptions.GetLocation(CurrentModelHandle, X, Y);
          Node.X := X;
          Node.Y := Y;
          NodeList.Add(Node);
        except
          Node.Free;
          raise;
        end;
      finally
        NodeOptions.Free;
      end;
    end;

    ProjectOptions := TProjectOptions.Create;
    try
      Separator := ProjectOptions.CopyDelimiter[CurrentModelHandle]
    finally
      ProjectOptions.Free;
    end;

    Limit := QuadLayer.NumObjects(CurrentModelHandle,
      pieElementObject);
    for Index := 0 to Limit -1 do
    begin
      ElementOptions := TElementObjectOptions.Create(CurrentModelHandle,
        QuadLayer.LayerHandle, Index);
      try
        AContour := TElementContour.Create(TElementNode, Separator);
        ContourList.Add(AContour);
        for NodeIndex := 0 to ElementOptions.NumberOfNodes
          (CurrentModelHandle) -1 do
        begin
          NodeNumber := ElementOptions.GetNthNodeNumber(CurrentModelHandle,
            NodeIndex) -1;
          Node := NodeList[NodeNumber] as TNode;
          ElementNode := TElementNode.Create;
          AContour.AddPoint(ElementNode);
          ElementNode.X := Node.X;
          ElementNode.Y := Node.Y;
        end;
        NodeNumber := ElementOptions.GetNthNodeNumber(CurrentModelHandle,
          0) -1;
        Node := NodeList[NodeNumber] as TNode;
        ElementNode := TElementNode.Create;
        AContour.AddPoint(ElementNode);
        ElementNode.X := Node.X;
        ElementNode.Y := Node.Y;
        AContour.MakeDefaultHeading;
      finally
        ElementOptions.Free;
      end;
    end;
  finally
    QuadLayer.Free(CurrentModelHandle);
  end;

end;

{ TNode }

constructor TNode.Create;
begin
  inherited;
  SegmentList := TList.Create;
end;

destructor TNode.Destroy;
begin
  SegmentList.Free;
  inherited;
end;

procedure TNode.Draw;
const
  Radius = 3;
var
  OldColor : TColor;

begin
  OldColor := ZoomBox.PBCanvas.Brush.Color;
  try
    if Selected then
    begin
      ZoomBox.PBCanvas.Brush.Color := clBlack;
    end
    else
    begin
      ZoomBox.PBCanvas.Brush.Color := clWhite;
    end;
    ZoomBox.PBCanvas.Ellipse(
      XCoord-Radius,YCoord-Radius,
      XCoord+Radius,YCoord+Radius);
  finally
    ZoomBox.PBCanvas.Brush.Color := OldColor;
  end;
end;

procedure TfrmMeshToContour.zbMainPaint(Sender: TObject);
var
  Index : integer;
  Segment : TSegment;
  LassoPoint : TRBWZoomPoint;
  OldStyle : TPenStyle;
begin
  inherited;
  for Index := 0 to SegmentList.Count -1 do
  begin
    Segment := SegmentList[Index] as TSegment;
    Segment.Draw;
  end;
  if Lasso.Count > 0 then
  begin
    OldStyle := zbMain.PBCanvas.Pen.Style;
    try
      zbMain.PBCanvas.Pen.Style := psDash;

      LassoPoint := Lasso[0] as TRBWZoomPoint;
      zbMain.PBCanvas.MoveTo(LassoPoint.XCoord,LassoPoint.YCoord);
      for Index := 1 to Lasso.Count -1 do
      begin
        LassoPoint := Lasso[Index] as TRBWZoomPoint;
        zbMain.PBCanvas.LineTo(LassoPoint.XCoord,LassoPoint.YCoord);
      end;
    finally
      zbMain.PBCanvas.Pen.Style := OldStyle;
    end;
  end;
end;

class function TNode.GetZoomBox: TRBWZoomBox;
begin
  result := frmMeshToContour.zbMain;
end;

function TNode.Select(const AnX, AY : integer): boolean;
begin
  if (Abs(AnX - XCoord) <= SelectionWidth) and (Abs(AY - YCoord) <= SelectionWidth) then
  begin
    Selected := not Selected;;
    result := True;
  end
  else
  begin
    result := False;
  end;
end;

procedure TNode.SetSelected(const Value: boolean);
var
  Index : integer;
  Segment : TSegment;
begin
  FSelected := Value;
  if not Selected then
  begin
    for Index := 0 to SegmentList.Count -1 do
    begin
      Segment := SegmentList[Index];
      Segment.Selected := False;
    end;
  end;

end;

{ TSegment }

procedure TSegment.Draw;
var
    OldWidth : integer;
    Canvas : TCanvas;
begin
  Canvas := Node1.ZoomBox.PBCanvas;
  OldWidth := Canvas.Pen.Width;
  try
    if Selected then
    begin
      Canvas.Pen.Width := 3;
    end;
    Canvas.MoveTo(Node1.XCoord,Node1.YCoord);
    Canvas.LineTo(Node2.XCoord,Node2.YCoord);
  finally
    Canvas.Pen.Width := OldWidth;
  end;
  Node1.Draw;
  Node2.Draw;
end;

function TSegment.OtherNode(const ANode: TNode): TNode;
begin
  if ANode = Node1 then
  begin
    result := Node2;
  end
  else if ANode = Node2 then
  begin
    result := Node1;
  end
  else
  begin
    result := nil;
    Assert(False);
  end;
end;

function TSegment.Select(const X, Y: integer): boolean;
var
  MinX, MinY, MaxX, MaxY : integer;
  XPos, YPos : extended;
  Slope : extended;
  Intercept : extended;
begin
  result := False;
  if Node1.XCoord < Node2.XCoord then
  begin
    MinX := Node1.XCoord - SelectionWidth;
    MaxX := Node2.XCoord + SelectionWidth;
  end
  else
  begin
    MaxX := Node1.XCoord + SelectionWidth;
    MinX := Node2.XCoord - SelectionWidth;
  end;
  if (X > MaxX) or (X < MinX) then
  begin
    Exit;
  end;
  if Node1.YCoord < Node2.YCoord then
  begin
    MinY := Node1.YCoord - SelectionWidth;
    MaxY := Node2.YCoord + SelectionWidth;
  end
  else
  begin
    MaxY := Node1.YCoord + SelectionWidth;
    MinY := Node2.YCoord - SelectionWidth;
  end;
  if (Y > MaxY) or (Y < MinY) then
  begin
    Exit;
  end;
  if (Node1.YCoord = Node2.YCoord) or (Node1.XCoord = Node2.XCoord) then
  begin
    Result := True;
    Selected := not Selected;
    Exit;
  end;
  Slope := (Node2.Y - Node1.Y)/(Node2.X - Node1.X);
  Intercept := Node1.Y - Slope * Node1.X;
  if (MaxY - MinY)*frmMeshToContour.zbMain.VerticalExaggeration > (MaxX - MinX) then
  begin
    // Slope > 45 degrees: Get X
    YPos := Node1.ZoomBox.Y(Y);
    XPos := (YPos - Intercept)/Slope;
    if Abs(Node1.ZoomBox.XCoord(XPos) - X) <= SelectionWidth then
    begin
      Result := True;
      Selected := not Selected;;
      Exit;
    end;
  end
  else
  begin
    // Slope < 45 degrees
    XPos := Node1.ZoomBox.X(X);
    YPos := Slope*XPos + Intercept;
    if Abs(Node1.ZoomBox.YCoord(YPos) - Y) <= SelectionWidth then
    begin
      Result := True;
      Selected := not Selected;;
      Exit;
    end;
  end;
end;

procedure TSegment.SetSelected(const Value: boolean);
begin
  FSelected := Value;
  if Selected then
  begin
    if Node1 <> nil then
    begin
      Node1.Selected := True;
    end;
    if Node2 <> nil then
    begin
      Node2.Selected := True;
    end;
  end;
end;

procedure TfrmMeshToContour.Select(const X, Y: Integer);
var
  NodeIndex, SegmentIndex : integer;
  ANode : TNode;
  ASegment : TSegment;
begin
  for NodeIndex := 0 to NodeList.Count -1 do
  begin
    ANode := NodeList[NodeIndex] as TNode;
    if ANode.Select(X, Y) then
    begin
      zbMain.Invalidate;
      Exit;
    end;
  end;
  for SegmentIndex := 0 to SegmentList.Count -1 do
  begin
    ASegment := SegmentList[SegmentIndex] as TSegment;
    if ASegment.Select(X, Y) then
    begin
      zbMain.Invalidate;
      Exit;
    end;
  end;

end;


procedure TfrmMeshToContour.DeselectAll;
var
  Index : integer;
  ANode : TNode;
  ASegment : TSegment;
begin
  for Index := 0 to NodeList.Count -1 do
  begin
    ANode := NodeList[Index] as TNode;
    ANode.Selected := False;
  end;
  for Index := 0 to SegmentList.Count -1 do
  begin
    ASegment := SegmentList[Index] as TSegment;
    ASegment.Selected := False;
  end;
  zbMain.Invalidate;
end;

procedure TfrmMeshToContour.AddLassoPoint(const X, Y: Integer);
var
  APoint : TRBWZoomPoint;
begin
  if (Lasso.Count = 0) or (PreviousX <> X) or (PreviousY <> Y) then
  begin
    APoint := TRBWZoomPoint.Create(zbMain);
    APoint.XCoord := X;
    APoint.YCoord := Y;
    Lasso.Add(APoint);
    zbMain.Invalidate;
    PreviousX := X;
    PreviousY := Y;
  end;

end;

procedure TfrmMeshToContour.zbMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  ShiftDown := (ssShift in Shift);
  if (sbSelect.Down or sbLasso.Down) and not ShiftDown then
  begin
    DeselectAll;
  end;
  if sbSelect.Down then
  begin
    Select(X,Y);
  end
  else if sbLasso.Down then
  begin
    AddLassoPoint(X,Y);
    timerLasso.Enabled := True;
  end
end;

procedure TfrmMeshToContour.SelectWithLasso;
var
  AVertex, AnotherVertex : TRBWZoomPoint;
  Index : integer;
  ANode : TNode;
  ASegment : TSegment;
  TempPointList : TList;
begin
  AVertex := Lasso[0] as TRBWZoomPoint;
  AnotherVertex := TRBWZoomPoint.Create(zbMain);
  try
    AnotherVertex.X := AVertex.X;
    AnotherVertex.Y := AVertex.Y;
    Lasso.Add(AnotherVertex);
  except
    AnotherVertex.Free;
    raise;
  end;
  TempPointList := TList.Create;
  try

    for Index := 0 to SegmentList.Count -1 do
    begin
      ASegment := SegmentList[Index] as TSegment;
      if PointInsideLasso((ASegment.Node1.X + ASegment.Node2.X)/2,
       (ASegment.Node1.Y + ASegment.Node2.Y)/2) then
      begin
        ASegment.Selected := not ASegment.Selected;
        TempPointList.Add(ASegment.Node1);
        TempPointList.Add(ASegment.Node2);
      end;
    end;
    for Index := 0 to NodeList.Count -1 do
    begin
      ANode := NodeList[Index] as TNode;
      if PointInsideLasso(ANode.X, ANode.Y)
        and (TempPointList.IndexOf(ANode) < 0) then
      begin
        ANode.Selected := not ANode.Selected;
      end;
    end;
  finally
    TempPointList.Free;
  end;
  Lasso.Clear;
  zbMain.Invalidate;

end;


function TfrmMeshToContour.PointInsideLasso(X, Y  : extended) : boolean;
var
  VertexIndex : integer;
  AVertex, AnotherVertex : TRBWZoomPoint;
begin   // based on CACM 112
  if Lasso.Count < 3 then
  begin
    result := false;
    Exit;
  end;

  AVertex := Lasso[0] as TRBWZoomPoint;
  AnotherVertex := Lasso[Lasso.Count -1] as TRBWZoomPoint;
  if (AVertex.X <> AnotherVertex.X) or
    (AVertex.Y <> AnotherVertex.Y) then
  begin
    result := False;
    Exit;
  end;

  result := true;
  For VertexIndex := 0 to Lasso.Count -2 do
  begin
    AVertex := Lasso[VertexIndex] as TRBWZoomPoint;
    AnotherVertex := Lasso[VertexIndex+1] as TRBWZoomPoint;
    if ((Y <= AVertex.Y) = (Y > AnotherVertex.Y)) and
       (X - AVertex.X - (Y - AVertex.Y) *
         (AnotherVertex.X - AVertex.X)/
         (AnotherVertex.Y - AVertex.Y) < 0) then
      begin
        result := not result;
      end;
  end;
  result := not result;
end;

procedure TfrmMeshToContour.zbMainMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  CurrentX := X;
  CurrentY := Y;
end;

procedure TfrmMeshToContour.timerLassoTimer(Sender: TObject);
begin
  inherited;
  AddLassoPoint(CurrentX, CurrentY);
end;

procedure TfrmMeshToContour.zbMainMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbLasso.Down then
  begin
    timerLasso.Enabled := False;
    SelectWithLasso;
  end;


end;

procedure TfrmMeshToContour.btnOKClick(Sender: TObject);
var
  SelectedSegments : TList;
  SelectedNodes : TList;
  Index : integer;
  ASegment : TSegment;
  ANode : TNode;
  ContourSegmentList : TContourSegmentList;
  LastNode : TNode;
  SegmentIndex : integer;
  FoundNextSegment : boolean;
  AContour : TContour;
  ProjectOptions : TProjectOptions;
  Separator : char;
begin
  inherited;
  SelectedSegments := TList.Create;
  SelectedNodes := TList.Create;
  try
    for Index := 0 to SegmentList.Count -1 do
    begin
      ASegment := SegmentList[Index] as TSegment;
      if ASegment.Selected then
      begin
        SelectedSegments.Add(ASegment);
      end;
    end;
    for Index := 0 to NodeList.Count -1 do
    begin
      ANode := NodeList[Index] as TNode;
      if ANode.Selected then
      begin
        SelectedNodes.Add(ANode);
      end;
    end;
    while SelectedSegments.Count > 0 do
    begin
      ContourSegmentList := TContourSegmentList.Create;
      SegmentToContours.Add(ContourSegmentList);
      ASegment := SelectedSegments[0];
      SelectedSegments.Delete(0);
      ContourSegmentList.Add(ASegment);
      ContourSegmentList.FirstNode := ASegment.Node1;
      LastNode := ASegment.Node2;
      repeat
        FoundNextSegment := False;
        for SegmentIndex := 0 to LastNode.SegmentList.Count -1 do
        begin
          ASegment := LastNode.SegmentList[SegmentIndex];
          if ASegment.Selected and (SelectedSegments.IndexOf(ASegment) >=0) then
          begin
            ContourSegmentList.Add(ASegment);
            LastNode := ASegment.OtherNode(LastNode);
            FoundNextSegment := True;
            SelectedSegments.Remove(ASegment);
            break;
          end;
        end;
      until not FoundNextSegment;
      repeat
        FoundNextSegment := False;
        for SegmentIndex := 0 to ContourSegmentList.FirstNode.SegmentList.Count -1 do
        begin
          ASegment := ContourSegmentList.FirstNode.SegmentList[SegmentIndex];
          if ASegment.Selected and (SelectedSegments.IndexOf(ASegment) >=0) then
          begin
            ContourSegmentList.Insert(0,ASegment);
            ContourSegmentList.FirstNode := ASegment.OtherNode(ContourSegmentList.FirstNode );
            FoundNextSegment := True;
            SelectedSegments.Remove(ASegment);
            break;
          end;
        end;
      until not FoundNextSegment;
    end;
    for Index := 0 to SegmentToContours.Count -1 do
    begin
      ContourSegmentList := SegmentToContours[Index] as TContourSegmentList;
      ANode := ContourSegmentList.FirstNode;
      SelectedNodes.Remove(ANode);
      for SegmentIndex := 0 to ContourSegmentList.Count -1 do
      begin
        ASegment := ContourSegmentList[SegmentIndex];
        ANode := ASegment.OtherNode(ANode);
        SelectedNodes.Remove(ANode);
      end;
    end;

    ProjectOptions := TProjectOptions.Create;
    try
      Separator := ProjectOptions.CopyDelimiter[CurrentModelHandle]
    finally
      ProjectOptions.Free;
    end;

    for Index := 0 to SegmentToContours.Count -1 do
    begin
      ContourSegmentList := SegmentToContours[Index] as TContourSegmentList;
      AContour := TContour.Create(TNode, Separator);
      try
        ContourList.Add(AContour);
      except
        AContour.Free;
      end;

      AContour.OwnsPoints := False;
      ANode := ContourSegmentList.FirstNode;
      AContour.AddPoint(ANode);
      for SegmentIndex := 0 to ContourSegmentList.Count -1 do
      begin
        ASegment := ContourSegmentList[SegmentIndex];
        ANode := ASegment.OtherNode(ANode);
        AContour.AddPoint(ANode);
      end;
      AContour.MakeDefaultHeading;
    end;
    for Index := 0 to SelectedNodes.Count -1 do
    begin
      AContour := TContour.Create(TNode, Separator);
      try
        ContourList.Add(AContour);
      except
        AContour.Free;
      end;
      AContour.OwnsPoints := False;
      ANode := SelectedNodes[Index];
      AContour.AddPoint(ANode);
      AContour.MakeDefaultHeading;
    end;



  finally
    SelectedSegments.Free;
    SelectedNodes.Free;
  end;

end;

{ TElementNode }

procedure TElementNode.Draw;
begin

end;

class function TElementNode.GetZoomBox: TRBWZoomBox;
begin
  result := frmMeshToContour.zbMain;
end;

{ TElementContour }

procedure TElementContour.Draw;
begin

end;

procedure TfrmMeshToContour.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

end.
