unit frmSetParamLockUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, StdCtrls, Buttons, ExtCtrls, AnePIE, TreeUnit, OptionsUnit;

type
  TLockIsParam = class(TIsParam)
    Lock : TParamLock;
  end;

  TfrmSetParamLock = class(TForm)
    Panel1: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    tvLayers: TTreeView;
    ImageList1: TImageList;
    cbLockName: TCheckBox;
    cbLockUnits: TCheckBox;
    cbLockType: TCheckBox;
    cbLockInfo: TCheckBox;
    cbLockDefVal: TCheckBox;
    cbDontOverride: TCheckBox;
    cbInhibitDelete: TCheckBox;
    cbLockKind: TCheckBox;
    cbDontEvalColor: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure tvLayersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
  private
    CheckBoxArray : array [Low(TParamLockValues)..High(TParamLockValues)] of TCheckBox;
    procedure SetImageIndex(Node: TTreeNode);
    procedure SetParentImageIndex(Node: TTreeNode);
    procedure SetChildIndexes(Node: TTreeNode);
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

uses UtilityFunctions, ANECB;

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

end;

procedure TfrmSetParamLock.GetData;
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
//  Lock : string;
  LastGroupNode : TTreeNode;
  LockIsParam : TLockIsParam;
begin
  LayerStringList := TStringList.Create;
  ParameterList := TStringList.Create;
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieAnyLayer], LayerStringList);
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
end;

procedure TfrmSetParamLock.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmSetParamLock.SetChildIndexes(Node: TTreeNode);
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
end;

procedure TfrmSetParamLock.SetImageIndex(Node: TTreeNode);
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
end;

procedure TfrmSetParamLock.SetParentImageIndex(Node: TTreeNode);
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
end;

procedure TfrmSetParamLock.tvLayersMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if tvLayers.Selected <> nil then
  begin
    if htOnIcon in tvLayers.GetHitTestInfoAt(X,Y) then
    begin
      SetImageIndex(tvLayers.Selected);
      tvLayers.Invalidate;
      SetCheckBoxes;
    end;
  end;
end;

procedure TfrmSetParamLock.SetCheckBoxes;
var
  InParam, OutParam, TempParam, AllParam :  TParamLock;
//  LayerIndex : integer;
//  LayerNode : TTreeNode;
//  Layer : TLayerOptions;
  ParameterNode : TTreeNode;
//  Parameter : TParameterOptions;
  IsParam : TLockIsParam;
  ParamIndex : TParamLockValues;
  CheckBox : TCheckBox;
begin
  for ParamIndex := Low(TParamLockValues) to High(TParamLockValues) do
  begin
    Include(AllParam,ParamIndex);
  end;
  InParam := [];
  OutParam := [];

  ParameterNode := tvLayers.Items.GetFirstNode;
  while ParameterNode <> nil do
  begin
    IsParam := ParameterNode.Data;
    if IsParam.IsParam and (ParameterNode.ImageIndex = 1) then
    begin
      TempParam := IsParam.Lock;
      InParam := InParam + TempParam;
      TempParam := AllParam - TempParam;
      OutParam := OutParam + TempParam;
    end;
    ParameterNode := ParameterNode.GetNext;
  end;
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
end;

procedure TfrmSetParamLock.BitBtn1Click(Sender: TObject);
var
//  LayerIndex : integer;
  LayerNode : TTreeNode;
  Layer : TLayerOptions;
  ParameterNode : TTreeNode;
  Parameter : TParameterOptions;
  IsParam : TLockIsParam;
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

  ParameterNode := tvLayers.Items.GetFirstNode;
  while ParameterNode <> nil do
  begin
//    ParameterNode := tvLayers.Items[LayerIndex];
    IsParam := ParameterNode.Data;
    if IsParam.IsParam and (ParameterNode.ImageIndex = 1) then
    begin
      LayerNode := ParameterNode.Parent;
      Layer := TLayerOptions.CreateWithName(LayerNode.Text,
        CurrentModelHandle);
      try
        Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
          ParameterNode.Text, CurrentModelHandle);
        try
          Parameter.PlusLockSet[CurrentModelHandle] := PlusLock;
          Parameter.MinusLockSet[CurrentModelHandle] := MinusLock;
        finally
          Parameter.Free
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;
    ParameterNode := ParameterNode.GetNext;
  end;
end;

end.
