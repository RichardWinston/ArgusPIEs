unit frmSetParamLockUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, StdCtrls, Buttons, ExtCtrls, AnePIE, OptionsUnit,
  VirtualTrees;

type
  PLockIsParam = ^TLockIsParam;
  TLockIsParam = record
    Name: string;
    IsLayer : boolean;
    Lock : TParamLock;
    AnObject: TObject;
  end;

  TfrmSetParamLock = class(TForm)
    Panel1: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    cbLockName: TCheckBox;
    cbLockUnits: TCheckBox;
    cbLockType: TCheckBox;
    cbLockInfo: TCheckBox;
    cbLockDefVal: TCheckBox;
    cbDontOverride: TCheckBox;
    cbInhibitDelete: TCheckBox;
    cbLockKind: TCheckBox;
    cbDontEvalColor: TCheckBox;
    btnAbout: TButton;
    vstLayers: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure tvLayersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vstLayersGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vstLayersChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
  private
    CheckBoxArray : array [Low(TParamLockValues)..High(TParamLockValues)] of TCheckBox;
//    procedure SetImageIndex(Node: TTreeNode);
//    procedure SetParentImageIndex(Node: TTreeNode);
//    procedure SetChildIndexes(Node: TTreeNode);
    procedure Moved(var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    procedure SetCheckBoxes;
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    procedure GetData;
    { Public declarations }
  end;

var
  frmSetParamLock: TfrmSetParamLock;

implementation

uses UtilityFunctions, ANECB, frmAboutUnit;

{$R *.DFM}

procedure TfrmSetParamLock.FormCreate(Sender: TObject);
var
  DllDirectory : String;
begin
  inherited;
  if GetDllDirectory(GetDLLName, DllDirectory) then
  begin
    HelpFile := DllDirectory + '\' + HelpFile;
  end;
  CheckBoxArray[plName] := cbLockName;
  CheckBoxArray[plUnits] := cbLockUnits;
  CheckBoxArray[plType] := cbLockType;
  CheckBoxArray[plInfo] := cbLockInfo;
  CheckBoxArray[plDef_Val] := cbLockDefVal;
  CheckBoxArray[plDont_Override] := cbDontOverride;
  CheckBoxArray[plInhibit_Delete] := cbInhibitDelete;
  CheckBoxArray[plKind] := cbLockKind;
  CheckBoxArray[plDontEvalColor] := cbDontEvalColor;
  Constraints.MinWidth := Width;

end;

procedure TfrmSetParamLock.GetData;
{
var
  LayerStringList : TStringList;
  Project : TProjectOptions;
  LastNode : TTreeNode;
  LayerIndex : integer;
  ParameterList : TStringList;
  Layer : TLayerOptions;
  ParameterIndex : integer;
  LayerType : TPIELayerType;
  Parameter : TParameterOptions;
  LastGroupNode : TTreeNode;
  LockIsParam : TLockIsParam;
}
var
  LayerStringList : TStringList;
  Project : TProjectOptions;
  LastNode : PVirtualNode;
  ParamNode : PVirtualNode;
  LayerIndex : integer;
  ParameterList : TStringList;
  Layer : TLayerOptions;
  ParameterIndex : integer;
  LayerType : TPIELayerType;
  Parameter : TParameterOptions;
  LastGroupNode : PVirtualNode;
  AReference : PLockIsParam;
begin
  LayerStringList := TStringList.Create;
  ParameterList := TStringList.Create;
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
    pieGridLayer,pieDataLayer,pieDomainLayer, pieGroupLayer], LayerStringList);
    LastNode:= nil;
    LastGroupNode := nil;
    vstLayers.RootNodeCount := 0;
    vstLayers.NodeDataSize := SizeOf(TLockIsParam);
    for LayerIndex := 0 to LayerStringList.Count -1 do
    begin
      Layer := TLayerOptions.CreateWithName(LayerStringList[LayerIndex],
        CurrentModelHandle);
        LayerType := Layer.LayerType[CurrentModelHandle];
        if LayerType = pieGroupLayer then
        begin
          vstLayers.RootNodeCount := vstLayers.RootNodeCount + 1;
          if LastNode = nil then
          begin
            LastNode := vstLayers.GetFirst;
          end
          else
          begin
            if LastGroupNode = nil then
            begin
              LastNode := vstLayers.GetNextSibling(LastNode);
            end
            else
            begin
              LastNode := vstLayers.GetNextSibling(LastGroupNode);
            end;
          end;
          LastNode.CheckType := ctTriStateCheckBox;

          AReference := vstLayers.GetNodeData(LastNode);
          AReference^.Name := LayerStringList[LayerIndex];
          AReference^.AnObject := Layer;
          AReference^.IsLayer := True;

          LastGroupNode := LastNode;
        end
        else
        begin
          if Layer.NumParameters(CurrentModelHandle,
            pieGeneralSubParam) = 0 then
           begin
             Layer.Free(CurrentModelHandle);
             Continue;
           end;

          if LastGroupNode = nil then
          begin
            vstLayers.RootNodeCount := vstLayers.RootNodeCount + 1;
            if LastNode = nil then
            begin
              LastNode := vstLayers.GetFirst;
            end
            else
            begin
              LastNode := vstLayers.GetNextSibling(LastNode);
            end;

            LastNode.CheckType := ctTriStateCheckBox;

            AReference := vstLayers.GetNodeData(LastNode);
            AReference^.Name := LayerStringList[LayerIndex];
            AReference^.AnObject := Layer;
            AReference^.IsLayer := True;
          end
          else
          begin
            LastNode := vstLayers.AddChild(LastGroupNode, nil);
            AReference := vstLayers.GetNodeData(LastNode);
            LastNode.CheckType := ctTriStateCheckBox;
            AReference^.Name := LayerStringList[LayerIndex];
            AReference^.AnObject := Layer;
            AReference^.IsLayer := True;
          end;
        end;

        if LayerType in [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
          pieGridLayer,pieDataLayer,pieDomainLayer] then
        begin
          Layer.GetParameterNames(CurrentModelHandle,ParameterList);
          for ParameterIndex := 0 to ParameterList.Count -1 do
          begin
            Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
              ParameterList[ParameterIndex], CurrentModelHandle);
            //try

              ParamNode := vstLayers.AddChild(LastNode, nil);
              ParamNode.CheckType := ctCheckBox;
              AReference := vstLayers.GetNodeData(ParamNode);
              AReference^.Name := ParameterList[ParameterIndex];
              AReference^.AnObject := Parameter;
              AReference^.IsLayer := false;
              AReference^.Lock := Parameter.LockSet[CurrentModelHandle];

              {LockIsParam := TLockIsParam.Create;
              LockIsParam.IsParam := True;
              LockIsParam.Lock := Parameter.LockSet[CurrentModelHandle];
              tvLayers.Items.AddChildObject(LastNode,
                ParameterList[ParameterIndex],LockIsParam); }
            {finally
              Parameter.Free;
            end;}
          end;
        end;
{      finally
        Layer.Free(CurrentModelHandle);
      end;   }
    end;
  finally
    LayerStringList.Free;
    ParameterList.Free;
    Project.Free;
  end;
{
  LayerStringList := TStringList.Create;
  ParameterList := TStringList.Create;
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
    pieGridLayer,pieDataLayer,pieDomainLayer, pieGroupLayer], LayerStringList);
    tvLayers.Items.Clear;
    LastNode:= nil;
    LastGroupNode := nil;
    for LayerIndex := 0 to LayerStringList.Count -1 do
    begin
      Layer := TLayerOptions.CreateWithName(LayerStringList[LayerIndex],
        CurrentModelHandle);
      try
        LayerType := Layer.LayerType[CurrentModelHandle];
        if LayerType = pieGroupLayer then
        begin
          LockIsParam := TLockIsParam.Create;
          LockIsParam.IsParam := False;
          LastNode := tvLayers.Items.AddObject(LastGroupNode,
            LayerStringList[LayerIndex], LockIsParam);
          LastGroupNode := LastNode;
        end
        else
        begin
          if Layer.NumParameters(CurrentModelHandle,
            pieGeneralSubParam) = 0 then Continue;

          if LastGroupNode = nil then
          begin
            LockIsParam := TLockIsParam.Create;
            LockIsParam.IsParam := False;
            LastNode := tvLayers.Items.AddObject(LastNode,
              LayerStringList[LayerIndex], LockIsParam);
          end
          else
          begin
            LockIsParam := TLockIsParam.Create;
            LockIsParam.IsParam := False;
            LastNode := tvLayers.Items.AddChildObject(LastGroupNode,
              LayerStringList[LayerIndex], LockIsParam);
          end;
        end;

        if LayerType in [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
          pieGridLayer,pieDataLayer,pieDomainLayer] then
        begin
          Layer.GetParameterNames(CurrentModelHandle,ParameterList);
          for ParameterIndex := 0 to ParameterList.Count -1 do
          begin
            Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
              ParameterList[ParameterIndex], CurrentModelHandle);
            try
              LockIsParam := TLockIsParam.Create;
              LockIsParam.IsParam := True;
              LockIsParam.Lock := Parameter.LockSet[CurrentModelHandle];
              tvLayers.Items.AddChildObject(LastNode,
                ParameterList[ParameterIndex],LockIsParam);
            finally
              Parameter.Free;
            end;
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
}
end;

procedure TfrmSetParamLock.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

{procedure TfrmSetParamLock.SetChildIndexes(Node: TTreeNode);
var
  Child : TTreeNode;
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
end;    }

{procedure TfrmSetParamLock.SetImageIndex(Node: TTreeNode);
var
  AnImageIndex : integer;
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
end;   }

{procedure TfrmSetParamLock.SetParentImageIndex(Node: TTreeNode);
var
  Child : TTreeNode;
  OriginalIndex : integer;
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
end;  }

procedure TfrmSetParamLock.tvLayersMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
{  if tvLayers.Selected <> nil then
  begin
    if htOnIcon in tvLayers.GetHitTestInfoAt(X,Y) then
    begin
      SetImageIndex(tvLayers.Selected);
      tvLayers.Invalidate;
      SetCheckBoxes;
    end;
  end;  }
end;

procedure TfrmSetParamLock.SetCheckBoxes;
var
{  InParam, OutParam, TempParam, AllParam :  TParamLock;
  ParameterNode : TTreeNode;
  IsParam : TLockIsParam;
  ParamIndex : TParamLockValues;
  CheckBox : TCheckBox;
  FoundOne : boolean;    }
  InParam, OutParam, TempParam, AllParam :  TParamLock;
  ParameterNode : PVirtualNode;
  IsParam : PLockIsParam;
  ParamIndex : TParamLockValues;
  CheckBox : TCheckBox;
  FoundOne : boolean;
begin
  for ParamIndex := Low(TParamLockValues) to High(TParamLockValues) do
  begin
    Include(AllParam,ParamIndex);
  end;
  InParam := [];
  OutParam := [];

  FoundOne := False;
  ParameterNode := vstLayers.GetFirst;
  while ParameterNode <> nil do
  begin
    IsParam := vstLayers.GetNodeData(ParameterNode);
    if not IsParam^.IsLayer and
      (vstLayers.CheckState[ParameterNode] = csCheckedNormal) then
    begin
      TempParam := IsParam^.Lock;
      InParam := InParam + TempParam;
      TempParam := AllParam - TempParam;
      OutParam := OutParam + TempParam;
      FoundOne := True;
    end;
    ParameterNode := vstLayers.GetNext(ParameterNode);
  end;
  if FoundOne then
  begin


    for ParamIndex := Low(TParamLockValues) to High(TParamLockValues) do
    begin
      CheckBox := CheckBoxArray[ParamIndex];
      if (ParamIndex in InParam) and (ParamIndex in OutParam) then
      begin
        CheckBox.State := cbGrayed;
      end
      else if (ParamIndex in InParam) then
      begin
        CheckBox.State := cbChecked;
      end
      else if (ParamIndex in OutParam) then
      begin
        CheckBox.State := cbUnchecked;
      end
      else
      begin
        Assert(False);
      end;
    end;
  end
  else
  begin
    for ParamIndex := Low(TParamLockValues) to High(TParamLockValues) do
    begin
      CheckBox := CheckBoxArray[ParamIndex];
      CheckBox.State := cbUnchecked;
    end;
  end;
end;

procedure TfrmSetParamLock.BitBtn1Click(Sender: TObject);
var
  ParameterNode : PVirtualNode;
  Parameter : TParameterOptions;
  IsParam : PLockIsParam;
  PlusLock, MinusLock : TParamLock;
  CheckBox : TCheckBox;
  ParamLockIndex : TParamLockValues;
begin
  PlusLock := [];
  MinusLock := [];
  for ParamLockIndex := Low(TParamLockValues) to High(TParamLockValues) do
  begin
    CheckBox := CheckBoxArray[ParamLockIndex];
    if CheckBox.State = cbChecked then
    begin
      Include(PlusLock, ParamLockIndex);
    end
    else if CheckBox.State = cbUnchecked then
    begin
      Include(MinusLock, ParamLockIndex);
    end;
  end;

  ParameterNode := vstLayers.GetFirst;
  while ParameterNode <> nil do
  begin
    IsParam := vstLayers.GetNodeData(ParameterNode);
    if not IsParam^.IsLayer and
      (vstLayers.CheckState[ParameterNode] = csCheckedNormal) then
    begin
        Parameter := IsParam^.AnObject as TParameterOptions;
          Parameter.PlusLockSet[CurrentModelHandle] := PlusLock;
          Parameter.MinusLockSet[CurrentModelHandle] := MinusLock;
    end;
    ParameterNode := vstLayers.GetNext(ParameterNode);
  end;
end;

procedure TfrmSetParamLock.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

procedure TfrmSetParamLock.FormDestroy(Sender: TObject);
var
  Node: PVirtualNode;
  ARef: PLockIsParam;
begin
  Node := vstLayers.GetFirst;
  while Node <> nil do
  begin
    ARef := vstLayers.GetNodeData(Node);
    if ARef^.IsLayer then
    begin
      (ARef^.AnObject as TLayerOptions).Free(CurrentModelHandle);
    end
    else
    begin
      (ARef^.AnObject as TParameterOptions).Free;
    end;
    ARef^.AnObject := nil;
    ARef^.Name := '';
    Node := vstLayers.GetNext(Node);
  end;
end;

procedure TfrmSetParamLock.vstLayersGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PLockIsParam;

begin
  // A handler for the OnGetText event is always needed as it provides the tree with the string data to display.
  // Note that we are always using WideString.
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data^.Name;
end;

procedure TfrmSetParamLock.vstLayersChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  SetCheckBoxes;
end;

end.
