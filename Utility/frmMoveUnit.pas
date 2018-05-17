unit frmMoveUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AnePIE, ImgList, ComCtrls, ExtCtrls, StdCtrls, Buttons, ArgusDataEntry,
  OptionsUnit, WriteContourUnit, PointContourUnit, RbwZoomBox;

type
  TfrmMove = class(TfrmWriteContour)
    Panel1: TPanel;
    tvLayers: TTreeView;
    ImageList1: TImageList;
    adeX: TArgusDataEntry;
    adeY: TArgusDataEntry;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Button1: TButton;
    RbwZoomBox1: TRbwZoomBox;
    Button2: TButton;
    procedure tvLayersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject); override;
    procedure Button2Click(Sender: TObject);
  private
    procedure SetImageIndex(Node: TTreeNode);
    procedure SetParentImageIndex(Node: TTreeNode);
    procedure SetChildIndexes(Node: TTreeNode);
    procedure MoveInfoLayer(AName: string);
    procedure MoveDataLayer(AName: string);
    procedure MoveGridLayer(AName: string);
    procedure MoveMeshLayer(AName: string);
    procedure ReverseInfoLayer(AName: string);
    procedure ReverseDataLayer(AName: string);
    procedure ReverseMeshLayer(AName: string);
    procedure Flip;
    { Private declarations }
  public
    CurrentModelHandle: ANE_PTR;
    X, Y: double;
    procedure GetData;
    { Public declarations }
  end;

  TLayerType = class(TObject)
    LType: TPIELayerType;
  end;

procedure GMovePIE(aneHandle: ANE_PTR;
  const fileName: ANE_STR; layerHandle: ANE_PTR); cdecl;

procedure GFlipPIE(aneHandle: ANE_PTR;
  const fileName: ANE_STR; layerHandle: ANE_PTR); cdecl;

var
  frmMove: TfrmMove;

implementation

uses ANECB, UtilityFunctions, frmAboutUnit, frmEditUnit, frmEditGridUnit,
  frmDataEditUnit, frmDataValuesUnit, CheckVersionFunction,
  ExportProgressUnit;

{$R *.DFM}

procedure GFlipPIE(aneHandle: ANE_PTR;
  const fileName: ANE_STR; layerHandle: ANE_PTR); cdecl;
begin
  try
    Application.CreateForm(TfrmMove, frmMove);
    try
      frmMove.CurrentModelHandle := aneHandle;
      frmMove.GetData;
      frmMove.Button2Click(nil);
      frmMove.Flip;
    finally
      frmMove.Free;
    end;

  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;

end;

procedure GMovePIE(aneHandle: ANE_PTR;
  const fileName: ANE_STR; layerHandle: ANE_PTR); cdecl;
begin
  try
    Application.CreateForm(TfrmMove, frmMove);
    try
      frmMove.CurrentModelHandle := aneHandle;
      frmMove.GetData;
      frmMove.ShowModal;
    finally
      frmMove.Free;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

type
  TMovePoint = class(TArgusPoint)
    procedure Draw; override;
    class function GetZoomBox: TRBWZoomBox; override;
  end;

  TMoveContour = class(TContour)
    procedure Draw; override;
  end;

  { TfrmMove }

procedure TfrmMove.GetData;
var
  LayerStringList: TStringList;
  Project: TProjectOptions;
  LastNode: TTreeNode;
  LayerIndex: integer;
  ParameterList: TStringList;
  Layer: TLayerOptions;
  LayerType: TPIELayerType;
  LastGroupNode: TTreeNode;
  LayerTypeObject: TLayerType;
begin
  LayerStringList := TStringList.Create;
  ParameterList := TStringList.Create;
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieAnyLayer], LayerStringList);
    tvLayers.Items.Clear;
    LastNode := nil;
    LastGroupNode := nil;
    for LayerIndex := 0 to LayerStringList.Count - 1 do
    begin
      Layer := TLayerOptions.CreateWithName(LayerStringList[LayerIndex],
        CurrentModelHandle);
      try
        LayerType := Layer.LayerType[CurrentModelHandle];
        if LayerType = pieGroupLayer then
        begin
          LayerTypeObject := TLayerType.Create;
          LayerTypeObject.LType := LayerType;
          LastNode := tvLayers.Items.AddObject(LastGroupNode,
            LayerStringList[LayerIndex], LayerTypeObject);
          LastGroupNode := LastNode;
        end
        else if LayerType in [pieTriMeshLayer, pieQuadMeshLayer,
          pieInformationLayer,
          pieGridLayer, pieDataLayer, pieDomainLayer] then
        begin
          if LastGroupNode = nil then
          begin
            LayerTypeObject := TLayerType.Create;
            LayerTypeObject.LType := LayerType;
            LastNode := tvLayers.Items.AddObject(LastNode,
              LayerStringList[LayerIndex], LayerTypeObject);
          end
          else
          begin
            LayerTypeObject := TLayerType.Create;
            LayerTypeObject.LType := LayerType;
            LastNode := tvLayers.Items.AddChildObject(LastGroupNode,
              LayerStringList[LayerIndex], LayerTypeObject);
          end;
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;
  finally
    LayerStringList.Free;
    ParameterList.Free;
    Project.Free;
  end;
end;

procedure TfrmMove.SetChildIndexes(Node: TTreeNode);
var
  Child: TTreeNode;
begin
  Child := Node.GetFirstChild;
  while Child <> nil do
  begin
    if Child.ImageIndex <> Node.ImageIndex then
    begin
      Child.ImageIndex := Node.ImageIndex;
      Child.SelectedIndex := Node.ImageIndex;
      SetChildIndexes(Child);
    end;
    Child := Node.GetNextChild(Child);
  end;
end;

procedure TfrmMove.SetImageIndex(Node: TTreeNode);
var
  AnImageIndex: integer;
begin
  if Node <> nil then
  begin
    AnImageIndex := Node.ImageIndex - 1;
    if AnImageIndex < 0 then
    begin
      AnImageIndex := 1;
    end;

    Node.ImageIndex := AnImageIndex;
    Node.SelectedIndex := Node.ImageIndex;
    SetChildIndexes(Node);
    SetParentImageIndex(Node);
  end;
end;

procedure TfrmMove.SetParentImageIndex(Node: TTreeNode);
var
  Child: TTreeNode;
  OriginalIndex: integer;
begin
  Node := Node.Parent;
  if (Node <> nil) then
  begin
    OriginalIndex := Node.ImageIndex;
    Child := Node.GetFirstChild;
    if Child <> nil then
    begin
      Node.ImageIndex := Child.ImageIndex;
      Node.SelectedIndex := Node.ImageIndex;
      Child := Node.GetNextChild(Child);
      while (Child <> nil) and (Node.ImageIndex <> 2) do
      begin
        if Node.ImageIndex <> Child.ImageIndex then
        begin
          Node.ImageIndex := 2;
          Node.SelectedIndex := 2;
        end;
        Child := Node.GetNextChild(Child);
      end;
    end;
    if OriginalIndex <> Node.ImageIndex then
    begin
      SetParentImageIndex(Node);
    end;
  end;
end;

procedure TfrmMove.tvLayersMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if tvLayers.Selected <> nil then
  begin
    if htOnIcon in tvLayers.GetHitTestInfoAt(X, Y) then
    begin
      SetImageIndex(tvLayers.Selected);
      tvLayers.Invalidate;
    end;
  end;
end;

procedure TfrmMove.FormResize(Sender: TObject);
begin
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmMove.FormCreate(Sender: TObject);
var
  DllDirectory: string;
begin
  inherited;
  if GetDllDirectory(GetDLLName, DllDirectory) then
  begin
    HelpFile := DllDirectory + '\' + HelpFile;
  end;
  Constraints.MinWidth := Width;
end;

procedure TfrmMove.Button1Click(Sender: TObject);
begin
  ShowAbout;
end;

procedure TfrmMove.BitBtn1Click(Sender: TObject);
var
  LayerNode: TTreeNode;
  LayerType: TLayerType;
  Count: integer;
begin
  try
    X := StrToFloat(adeX.Text);
    Y := StrToFloat(adeY.Text);
  except on EConvertError do
    begin
      ModalResult := mrNone;
      raise;
    end;
  end;

  if (X = 0) and (Y = 0) then
  begin
    ModalResult := mrNone;
    Beep;
    MessageDlg('You need to set the distance you want to move.',
      mtWarning, [mbOK], 0);
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    Hide;
    Count := 0;
    LayerNode := tvLayers.Items.GetFirstNode;
    while LayerNode <> nil do
    begin
      if LayerNode.ImageIndex = 1 then
      begin
        inc(Count);
      end;
      LayerNode := LayerNode.GetNext;
    end;

    frmExportProgress := TfrmExportProgress.Create(nil);
    try
      frmExportProgress.CurrentModelHandle := CurrentModelHandle;
      frmExportProgress.ProgressBar1.Max := Count;
      frmExportProgress.ProgressBar1.Position := 0;
      frmExportProgress.Caption := 'Moving Layers';
      frmExportProgress.Show;

      LayerNode := tvLayers.Items.GetFirstNode;
      while LayerNode <> nil do
      begin
        if LayerNode.ImageIndex = 1 then
        begin
          LayerType := LayerNode.Data;
          case LayerType.LType of
            pieTriMeshLayer, pieQuadMeshLayer:
              begin
                MoveMeshLayer(LayerNode.Text);
              end;
            pieInformationLayer:
              begin
                MoveInfoLayer(LayerNode.Text);
              end;
            pieGridLayer:
              begin
                MoveGridLayer(LayerNode.Text);
              end;
            pieDataLayer:
              begin
                MoveDataLayer(LayerNode.Text);
              end;
            pieMapsLayer: Assert(False);
            pieDomainLayer:
              begin
                MoveInfoLayer(LayerNode.Text);
              end;
            pieGroupLayer: ; // do nothing
            pieAnyLayer: Assert(False);
          else
            Assert(False);
          end;
          frmExportProgress.ProgressBar1.StepIt;
          Application.ProcessMessages;
        end;

        LayerNode := LayerNode.GetNext;
      end;
    finally
      frmExportProgress.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMove.Flip;
var
  LayerNode: TTreeNode;
  LayerType: TLayerType;
begin

  LayerNode := tvLayers.Items.GetFirstNode;
  while LayerNode <> nil do
  begin
    if LayerNode.ImageIndex = 1 then
    begin
      LayerType := LayerNode.Data;
      case LayerType.LType of
        pieTriMeshLayer, pieQuadMeshLayer:
          begin
            ReverseMeshLayer(LayerNode.Text);
          end;
        pieInformationLayer:
          begin
            ReverseInfoLayer(LayerNode.Text);
          end;
        pieGridLayer:
          begin
            //            MoveGridLayer(LayerNode.Text);
          end;
        pieDataLayer:
          begin
            ReverseDataLayer(LayerNode.Text);
          end;
        pieMapsLayer: Assert(False);
        pieDomainLayer:
          begin
            ReverseInfoLayer(LayerNode.Text);
          end;
        pieGroupLayer: ; // do nothing
        pieAnyLayer: Assert(False);
      else
        Assert(False);
      end;
    end;

    LayerNode := LayerNode.GetNext;
  end;
end;

procedure TfrmMove.FormDestroy(Sender: TObject);
var
  LayerNode: TTreeNode;
  LayerType: TLayerType;
begin
  inherited;
  LayerNode := tvLayers.Items.GetFirstNode;
  while LayerNode <> nil do
  begin
    LayerType := LayerNode.Data;
    LayerType.Free;
    LayerNode := LayerNode.GetNext;
  end;
end;

procedure TfrmMove.MoveDataLayer(AName: string);
var
  layerHandle: ANE_PTR;
  Project: TProjectOptions;
  ValueIndex: integer;
  DataValue: TDataValues;
  Layer: TLayerOptions;
  Empty: boolean;
begin
  Project := TProjectOptions.Create;
  try
    layerHandle := Project.GetLayerByName(CurrentModelHandle, AName);

    if layerHandle <> nil then
    begin
      Layer := TLayerOptions.Create(layerHandle);
      try
        Empty := Layer.NumObjects(CurrentModelHandle, pieDataPointObject) = 0;
      finally
        Layer.Free(CurrentModelHandle);
      end;

      if not Empty then
      begin
        Application.CreateForm(TfrmDataEdit, frmDataEdit);
        try
          frmDataEdit.CurrentModelHandle := CurrentModelHandle;
          frmDataEdit.GetData(layerHandle, True);

          for ValueIndex := 0 to frmDataEdit.DataValues.Count - 1 do
          begin
            DataValue := frmDataEdit.DataValues[ValueIndex] as TDataValues;

            DataValue.X := DataValue.X + X;
            DataValue.Y := DataValue.Y + Y;
            Application.ProcessMessages;
          end;

          frmDataEdit.btnOKClick(nil)
        finally
          FreeAndNil(frmDataEdit);
        end;
      end;
    end;
  finally
    Project.free;
  end;
end;

procedure TfrmMove.MoveGridLayer(AName: string);
var
  layerHandle: ANE_PTR;
  Project: TProjectOptions;
  Layer: TLayerOptions;
  Empty: boolean;
begin
  Project := TProjectOptions.Create;
  try
    layerHandle := Project.GetLayerByName(CurrentModelHandle, AName);
    if layerHandle <> nil then
    begin
      Layer := TLayerOptions.Create(layerHandle);
      try
        Empty := Layer.NumObjects(CurrentModelHandle, pieBlockObject) = 0;
      finally
        Layer.Free(CurrentModelHandle);
      end;

      if not Empty then
      begin
        Application.CreateForm(TfrmEditGrid, frmEditGrid);
        try
          frmEditGrid.CurrentModelHandle := CurrentModelHandle;

          frmEditGrid.LayerHandle := layerHandle;
          frmEditGrid.GetGrid(AName);
          frmEditGrid.XOrigin := frmEditGrid.XOrigin + X;
          frmEditGrid.YOrigin := frmEditGrid.YOrigin + Y;
          frmEditGrid.btnOKClick(nil);
        finally
          frmEditGrid.Free;
        end;
      end;
    end;
  finally
    Project.free;
  end;
end;

procedure TfrmMove.MoveInfoLayer(AName: string);
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion: string;
  InfoText: ANE_STR;
  InfoTextString: string;
  ImportText: string;
  AString: ANE_STR;
  Project: TProjectOptions;
  OldCopyDelimiter: char;
  OldCopyIcon: ANE_BOOL;
  OldCopyName: ANE_BOOL;
  OldCopyParameters: ANE_BOOL;
  OldExportDelimiter: char;
  OldExportTitles: ANE_BOOL;
  layerHandle: ANE_PTR;
  Index, PointIndex: integer;
  AContour: TMoveContour;
  Node: TMovePoint;
  Limit: integer;
  Layer: TLayerOptions;
  Empty: boolean;
  OK_Version: boolean;
begin
  Project := TProjectOptions.Create;
  try
    layerHandle := Project.GetLayerByName(CurrentModelHandle, AName);

    OK_Version := CheckArgusVersion(CurrentModelHandle, MajorVersion,
      MinorVersion, Update, version, ArgusVersion);
    if OK_Version then
    begin
      OldCopyDelimiter := Project.CopyDelimiter[CurrentModelHandle];
      OldCopyIcon := Project.CopyIcon[CurrentModelHandle];
      OldCopyName := Project.CopyName[CurrentModelHandle];
      OldCopyParameters := Project.CopyParameters[CurrentModelHandle];
      OldExportDelimiter := Project.ExportDelimiter[CurrentModelHandle];
      OldExportTitles := Project.ExportTitles[CurrentModelHandle];

      if OldCopyDelimiter <> #9 then
      begin
        Project.CopyDelimiter[CurrentModelHandle] := #9;
      end;
      Project.CopyIcon[CurrentModelHandle] := True;
      Project.CopyName[CurrentModelHandle] := True;
      Project.CopyParameters[CurrentModelHandle] := True;
      if OldExportDelimiter <> #9 then
      begin
        Project.ExportDelimiter[CurrentModelHandle] := #9;
      end;
      Project.ExportTitles[CurrentModelHandle] := True;
    end;

    Application.CreateForm(TfrmEditNew, frmEditNew);
    try
      Layer := TLayerOptions.Create(layerHandle);
      try
        Empty := Layer.NumObjects(CurrentModelHandle, pieContourObject) = 0;
      finally
        Layer.Free(CurrentModelHandle);
      end;

      if not Empty then
      begin
        ANE_ExportTextFromOtherLayer(CurrentModelHandle, layerHandle,
          @InfoText);
        InfoTextString := string(InfoText);
        frmEditNew.ReadArgusContours(InfoTextString, TMoveContour,
          TMovePoint, #9);

        for index := 0 to frmEditNew.ContourList.Count - 1 do
        begin
          AContour := frmEditNew.ContourList.Items[index];
          Limit := AContour.FPoints.Count - 1;
          if (Limit > 0) and (AContour.FPoints[0] = AContour.FPoints[Limit])
            then
          begin
            Dec(Limit);
          end;
          for PointIndex := 0 to Limit do
          begin
            Node := AContour.FPoints[PointIndex];
            Node.X := Node.X + X;
            Node.Y := Node.Y + Y;
            Application.ProcessMessages;
          end;
        end;

        ImportText := frmEditNew.WriteContours;

        ANE_LayerClear(CurrentModelHandle, layerHandle, False);

        GetMem(AString, Length(ImportText) + 1);
        try
          StrPCopy(AString, ImportText);
          ANE_ImportTextToLayerByHandle(CurrentModelHandle, layerHandle,
            AString);
        finally
          FreeMem(AString);
        end;
      end;
    finally
      if OK_Version then
      begin
        if OldCopyDelimiter <> #9 then
        begin
          Project.CopyDelimiter[CurrentModelHandle] := OldCopyDelimiter;
        end;
        Project.CopyIcon[CurrentModelHandle] := OldCopyIcon;
        Project.CopyName[CurrentModelHandle] := OldCopyName;
        Project.CopyParameters[CurrentModelHandle] := OldCopyParameters;
        if OldExportDelimiter <> #9 then
        begin
          Project.ExportDelimiter[CurrentModelHandle] := OldExportDelimiter;
        end;
        Project.ExportTitles[CurrentModelHandle] := OldExportTitles;
      end;
      FreeAndNil(frmEditNew);
    end;
  finally
    Project.free;
  end;
end;

procedure TfrmMove.MoveMeshLayer(AName: string);
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion: string;
  InfoText: ANE_STR;
  InfoTextString: string;
  ImportText: string;
  AString: string;
  Project: TProjectOptions;
  OldCopyDelimiter: char;
  OldCopyIcon: ANE_BOOL;
  OldCopyName: ANE_BOOL;
  OldCopyParameters: ANE_BOOL;
  OldExportDelimiter: char;
  OldExportSeparator: char;
  OldExportTitles: ANE_BOOL;
  layerHandle: ANE_PTR;
  OldNodeLinePrefix: Char;
  OldElementLinePrefix: char;
  MeshStringList: TStringList;
  LineIndex: integer;
  NewString: string;
  TabPos: integer;
  TempString: string;
  Code: Integer;
  Value: double;
  ImportStr: PChar;
  Layer: TLayerOptions;
  Empty: boolean;
  OK_Version: boolean;
begin
  Code := 0;
  Project := TProjectOptions.Create;
  try
    layerHandle := Project.GetLayerByName(CurrentModelHandle, AName);

    OK_Version := CheckArgusVersion(CurrentModelHandle, MajorVersion,
      MinorVersion, Update, version, ArgusVersion);
    if OK_Version then
    begin
      OldCopyDelimiter := Project.CopyDelimiter[CurrentModelHandle];
      OldCopyIcon := Project.CopyIcon[CurrentModelHandle];
      OldCopyName := Project.CopyName[CurrentModelHandle];
      OldCopyParameters := Project.CopyParameters[CurrentModelHandle];
      OldExportDelimiter := Project.ExportDelimiter[CurrentModelHandle];
      OldExportTitles := Project.ExportTitles[CurrentModelHandle];
      OldNodeLinePrefix := Project.NodeLinePrefix[CurrentModelHandle];
      OldElementLinePrefix := Project.ElemLinePrefix[CurrentModelHandle];
      OldExportSeparator := Project.ExportSeparator[CurrentModelHandle];

      if OldCopyDelimiter <> #9 then
      begin
        Project.CopyDelimiter[CurrentModelHandle] := #9;
      end;
      Project.CopyIcon[CurrentModelHandle] := True;
      Project.CopyName[CurrentModelHandle] := True;
      Project.CopyParameters[CurrentModelHandle] := True;
      if OldExportDelimiter <> #9 then
      begin
        Project.ExportDelimiter[CurrentModelHandle] := #9;
      end;
      Project.ExportTitles[CurrentModelHandle] := True;
      Project.NodeLinePrefix[CurrentModelHandle] := 'N';
      Project.ElemLinePrefix[CurrentModelHandle] := 'E';
      if OldExportSeparator <> #9 then
      begin
        Project.ExportSeparator[CurrentModelHandle] := #9;
      end;
    end;

    try
      Layer := TLayerOptions.Create(layerHandle);
      try
        Empty := Layer.NumObjects(CurrentModelHandle, pieNodeObject) = 0;
      finally
        Layer.Free(CurrentModelHandle);
      end;

      if not Empty then
      begin
        ANE_ExportTextFromOtherLayer(CurrentModelHandle, layerHandle,
          @InfoText);
        InfoTextString := string(InfoText);

        MeshStringList := TStringList.Create;
        try
          MeshStringList.Text := InfoTextString;
          for LineIndex := MeshStringList.Count - 1 downto 0 do
          begin
            AString := MeshStringList[LineIndex];
            if AString = '' then
            begin
              MeshStringList.Delete(LineIndex);
            end
            else if (Length(AString) > 0) and (AString[1] = 'N') then
            begin
              AString := Trim(Copy(AString, 2, MAXINT));
              NewString := 'N' + #9;
              TabPos := Pos(#9, AString);

              TempString := Copy(AString, 1, TabPos - 1); // node index
              AString := Trim(Copy(AString, TabPos + 1, MAXINT));
              NewString := NewString + TempString + #9;
              TabPos := Pos(#9, AString);

              TempString := Copy(AString, 1, TabPos - 1); // X
              AString := Trim(Copy(AString, TabPos + 1, MAXINT));
              Val(TempString, Value, Code);
              Str(Value + X, TempString);
              NewString := NewString + TempString + #9;
              TabPos := Pos(#9, AString);

              if TabPos > 0 then
              begin
                TempString := Copy(AString, 1, TabPos - 1); // Y
              end
              else
              begin
                TempString := AString; // Y
              end;

              Val(TempString, Value, Code);
              Str(Value + Y, TempString);
              NewString := NewString + TempString;

              MeshStringList[LineIndex] := NewString;
            end;
            Application.ProcessMessages;
          end;

          ImportText := MeshStringList.Text;
        finally
          MeshStringList.Free;
        end;

        //      ImportText := frmEditNew.WriteContours;

        ANE_LayerClear(CurrentModelHandle, layerHandle, False);

        GetMem(ImportStr, Length(ImportText) + 1);
        try
          StrPCopy(ImportStr, ImportText);
          ANE_ImportTextToLayerByHandle(CurrentModelHandle, layerHandle,
            ImportStr);
        finally
          FreeMem(ImportStr);
        end;
      end;

    finally
      if OK_Version then
      begin
        if OldCopyDelimiter <> #9 then
        begin
          Project.CopyDelimiter[CurrentModelHandle] := OldCopyDelimiter;
        end;
        Project.CopyIcon[CurrentModelHandle] := OldCopyIcon;
        Project.CopyName[CurrentModelHandle] := OldCopyName;
        Project.CopyParameters[CurrentModelHandle] := OldCopyParameters;
        if OldExportDelimiter <> #9 then
        begin
          Project.ExportDelimiter[CurrentModelHandle] := OldExportDelimiter;
        end;
        Project.ExportTitles[CurrentModelHandle] := OldExportTitles;
        Project.NodeLinePrefix[CurrentModelHandle] := OldNodeLinePrefix;
        Project.ElemLinePrefix[CurrentModelHandle] := OldElementLinePrefix;
        if OldExportSeparator <> #9 then
        begin
          Project.ExportSeparator[CurrentModelHandle] := OldExportSeparator;
        end;
      end;
    end;
  finally
    Project.free;
  end;
end;

{ TMovePoint }

procedure TMovePoint.Draw;
begin

end;

class function TMovePoint.GetZoomBox: TRBWZoomBox;
begin
  result := frmMove.RbwZoomBox1;
end;

{ TMoveContour }

procedure TMoveContour.Draw;
begin

end;

procedure TfrmMove.Button2Click(Sender: TObject);
var
  LayerNode: TTreeNode;
begin
  inherited;
  LayerNode := tvLayers.Items.GetFirstNode;
  while LayerNode <> nil do
  begin
    LayerNode.ImageIndex := 1;
    LayerNode := LayerNode.GetNext;
  end;
  tvLayers.Invalidate;
end;

procedure TfrmMove.ReverseInfoLayer(AName: string);
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion: string;
  InfoText: ANE_STR;
  InfoTextString: string;
  ImportText: string;
  AString: ANE_STR;
  Project: TProjectOptions;
  OldCopyDelimiter: char;
  OldCopyIcon: ANE_BOOL;
  OldCopyName: ANE_BOOL;
  OldCopyParameters: ANE_BOOL;
  OldExportDelimiter: char;
  OldExportTitles: ANE_BOOL;
  layerHandle: ANE_PTR;
  Index, PointIndex: integer;
  AContour: TMoveContour;
  Node: TMovePoint;
  Limit: integer;
  Layer: TLayerOptions;
  Empty: boolean;
  OK_Version: boolean;
begin

  Project := TProjectOptions.Create;
  try
    layerHandle := Project.GetLayerByName(CurrentModelHandle, AName);

    OK_Version := CheckArgusVersion(CurrentModelHandle, MajorVersion,
      MinorVersion, Update, version, ArgusVersion);

    if OK_Version then
    begin
      OldCopyDelimiter := Project.CopyDelimiter[CurrentModelHandle];
      OldCopyIcon := Project.CopyIcon[CurrentModelHandle];
      OldCopyName := Project.CopyName[CurrentModelHandle];
      OldCopyParameters := Project.CopyParameters[CurrentModelHandle];
      OldExportDelimiter := Project.ExportDelimiter[CurrentModelHandle];
      OldExportTitles := Project.ExportTitles[CurrentModelHandle];

      if OldCopyDelimiter <> #9 then
      begin
        Project.CopyDelimiter[CurrentModelHandle] := #9;
      end;
      Project.CopyIcon[CurrentModelHandle] := True;
      Project.CopyName[CurrentModelHandle] := True;
      Project.CopyParameters[CurrentModelHandle] := True;
      if OldExportDelimiter <> #9 then
      begin
        Project.ExportDelimiter[CurrentModelHandle] := #9;
      end;
      Project.ExportTitles[CurrentModelHandle] := True;
    end;

    Application.CreateForm(TfrmEditNew, frmEditNew);
    try
      Empty := True;
      Layer := TLayerOptions.Create(layerHandle);
      try
        Empty := Layer.NumObjects(CurrentModelHandle, pieContourObject) = 0;
      finally
        Layer.Free(CurrentModelHandle);
      end;

      if not Empty then
      begin
        ANE_ExportTextFromOtherLayer(CurrentModelHandle, layerHandle,
          @InfoText);
        InfoTextString := string(InfoText);
        frmEditNew.ReadArgusContours(InfoTextString, TMoveContour,
          TMovePoint, #9);

        for index := 0 to frmEditNew.ContourList.Count - 1 do
        begin
          AContour := frmEditNew.ContourList.Items[index];
          Limit := AContour.FPoints.Count - 1;
          if (Limit > 0) and (AContour.FPoints[0] = AContour.FPoints[Limit])
            then
          begin
            Dec(Limit);
          end;
          for PointIndex := 0 to Limit do
          begin
            Node := AContour.FPoints[PointIndex];
            Node.Y := -Node.Y;
          end;

        end;

        ImportText := frmEditNew.WriteContours;

        ANE_LayerClear(CurrentModelHandle, layerHandle, False);

        GetMem(AString, Length(ImportText) + 1);
        try
          StrPCopy(AString, ImportText);
          ANE_ImportTextToLayerByHandle(CurrentModelHandle, layerHandle,
            AString);
        finally
          FreeMem(AString);
        end;
      end;
    finally
      if OK_Version then
      begin
        if OldCopyDelimiter <> #9 then
        begin
          Project.CopyDelimiter[CurrentModelHandle] := OldCopyDelimiter;
        end;
        Project.CopyIcon[CurrentModelHandle] := OldCopyIcon;
        Project.CopyName[CurrentModelHandle] := OldCopyName;
        Project.CopyParameters[CurrentModelHandle] := OldCopyParameters;
        if OldExportDelimiter <> #9 then
        begin
          Project.ExportDelimiter[CurrentModelHandle] := OldExportDelimiter;
        end;
        Project.ExportTitles[CurrentModelHandle] := OldExportTitles;
      end;
      FreeAndNil(frmEditNew);
    end;

  finally
    Project.free;
  end;
end;

procedure TfrmMove.ReverseDataLayer(AName: string);
var
  layerHandle: ANE_PTR;
  Project: TProjectOptions;
  ValueIndex: integer;
  DataValue: TDataValues;
  Layer: TLayerOptions;
  Empty: boolean;
begin
  Project := TProjectOptions.Create;
  try
    layerHandle := Project.GetLayerByName(CurrentModelHandle, AName);

    if layerHandle <> nil then
    begin
      Layer := TLayerOptions.Create(layerHandle);
      try
        Empty := Layer.NumObjects(CurrentModelHandle, pieDataPointObject) = 0;
      finally
        Layer.Free(CurrentModelHandle);
      end;

      if not Empty then
      begin
        Application.CreateForm(TfrmDataEdit, frmDataEdit);
        try
          frmDataEdit.CurrentModelHandle := CurrentModelHandle;
          frmDataEdit.GetData(layerHandle, False);

          for ValueIndex := 0 to frmDataEdit.DataValues.Count - 1 do
          begin
            DataValue := frmDataEdit.DataValues[ValueIndex] as TDataValues;

            DataValue.Y := -DataValue.Y;
          end;

          frmDataEdit.btnOKClick(nil)
        finally
          FreeAndNil(frmDataEdit);
        end;
      end;
    end;
  finally
    Project.free;
  end;
end;

procedure TfrmMove.ReverseMeshLayer(AName: string);
const
  MajorVersion = 4;
  MinorVersion = 2;
  Update = 0;
  version = 'w';
var
  ArgusVersion: string;
  InfoText: ANE_STR;
  InfoTextString: string;
  ImportText: string;
  AString: string;
  Project: TProjectOptions;
  OldCopyDelimiter: char;
  OldCopyIcon: ANE_BOOL;
  OldCopyName: ANE_BOOL;
  OldCopyParameters: ANE_BOOL;
  OldExportDelimiter: char;
  OldExportSeparator: char;
  OldExportTitles: ANE_BOOL;
  layerHandle: ANE_PTR;
  OldNodeLinePrefix: Char;
  OldElementLinePrefix: char;
  MeshStringList: TStringList;
  LineIndex: integer;
  NewString: string;
  TabPos: integer;
  TempString: string;
  Code: Integer;
  Value: double;
  ImportStr: PChar;
  Layer: TLayerOptions;
  Empty: boolean;
  OK_Version: boolean;
begin
  Code := 0;
  Project := TProjectOptions.Create;
  try
    layerHandle := Project.GetLayerByName(CurrentModelHandle, AName);
    OK_Version := CheckArgusVersion(CurrentModelHandle, MajorVersion,
      MinorVersion, Update, version, ArgusVersion);
    if OK_Version then
    begin
      OldCopyDelimiter := Project.CopyDelimiter[CurrentModelHandle];
      OldCopyIcon := Project.CopyIcon[CurrentModelHandle];
      OldCopyName := Project.CopyName[CurrentModelHandle];
      OldCopyParameters := Project.CopyParameters[CurrentModelHandle];
      OldExportDelimiter := Project.ExportDelimiter[CurrentModelHandle];
      OldExportTitles := Project.ExportTitles[CurrentModelHandle];
      OldNodeLinePrefix := Project.NodeLinePrefix[CurrentModelHandle];
      OldElementLinePrefix := Project.ElemLinePrefix[CurrentModelHandle];
      OldExportSeparator := Project.ExportSeparator[CurrentModelHandle];

      if OldCopyDelimiter <> #9 then
      begin
        Project.CopyDelimiter[CurrentModelHandle] := #9;
      end;
      Project.CopyIcon[CurrentModelHandle] := True;
      Project.CopyName[CurrentModelHandle] := True;
      Project.CopyParameters[CurrentModelHandle] := True;
      if OldExportDelimiter <> #9 then
      begin
        Project.ExportDelimiter[CurrentModelHandle] := #9;
      end;
      Project.ExportTitles[CurrentModelHandle] := True;
      Project.NodeLinePrefix[CurrentModelHandle] := 'N';
      Project.ElemLinePrefix[CurrentModelHandle] := 'E';
      if OldExportSeparator <> #9 then
      begin
        Project.ExportSeparator[CurrentModelHandle] := #9;
      end;
    end;
    try
      Layer := TLayerOptions.Create(layerHandle);
      try
        Empty := Layer.NumObjects(CurrentModelHandle, pieNodeObject) = 0;
      finally
        Layer.Free(CurrentModelHandle);
      end;

      if not Empty then
      begin
        ANE_ExportTextFromOtherLayer(CurrentModelHandle, layerHandle,
          @InfoText);
        InfoTextString := string(InfoText);

        MeshStringList := TStringList.Create;
        try
          MeshStringList.Text := InfoTextString;
          for LineIndex := MeshStringList.Count - 1 downto 0 do
          begin
            AString := MeshStringList[LineIndex];
            if AString = '' then
            begin
              MeshStringList.Delete(LineIndex);
            end
            else if (Length(AString) > 0) and (AString[1] = 'N') then
            begin
              AString := Trim(Copy(AString, 2, MAXINT));
              NewString := 'N' + #9;
              TabPos := Pos(#9, AString);

              TempString := Copy(AString, 1, TabPos - 1); // node index
              AString := Trim(Copy(AString, TabPos + 1, MAXINT));
              NewString := NewString + TempString + #9;
              TabPos := Pos(#9, AString);

              TempString := Copy(AString, 1, TabPos - 1); // X
              AString := Trim(Copy(AString, TabPos + 1, MAXINT));
              NewString := NewString + TempString + #9;
              TabPos := Pos(#9, AString);

              if TabPos > 0 then
              begin
                TempString := Copy(AString, 1, TabPos - 1); // Y
              end
              else
              begin
                TempString := AString; // Y
              end;

              Val(TempString, Value, Code);
              Str(-Value, TempString);
              NewString := NewString + TempString;

              MeshStringList[LineIndex] := NewString;
            end;
          end;

          ImportText := MeshStringList.Text;
        finally
          MeshStringList.Free;
        end;

        //      ImportText := frmEditNew.WriteContours;

        ANE_LayerClear(CurrentModelHandle, layerHandle, False);

        GetMem(ImportStr, Length(ImportText) + 1);
        try
          StrPCopy(ImportStr, ImportText);
          ANE_ImportTextToLayerByHandle(CurrentModelHandle, layerHandle,
            ImportStr);
        finally
          FreeMem(ImportStr);
        end;
      end;

    finally
      if OK_Version then
      begin
        if OldCopyDelimiter <> #9 then
        begin
          Project.CopyDelimiter[CurrentModelHandle] := OldCopyDelimiter;
        end;
        Project.CopyIcon[CurrentModelHandle] := OldCopyIcon;
        Project.CopyName[CurrentModelHandle] := OldCopyName;
        Project.CopyParameters[CurrentModelHandle] := OldCopyParameters;
        if OldExportDelimiter <> #9 then
        begin
          Project.ExportDelimiter[CurrentModelHandle] := OldExportDelimiter;
        end;
        Project.ExportTitles[CurrentModelHandle] := OldExportTitles;
        Project.NodeLinePrefix[CurrentModelHandle] := OldNodeLinePrefix;
        Project.ElemLinePrefix[CurrentModelHandle] := OldElementLinePrefix;
        if OldExportSeparator <> #9 then
        begin
          Project.ExportSeparator[CurrentModelHandle] := OldExportSeparator;
        end;
      end;
    end;
  finally
    Project.free;
  end;
end;

end.

