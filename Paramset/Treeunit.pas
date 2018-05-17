unit TreeUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ImgList, StdCtrls, RzCmboBx, RzLstBox, RzChkLst, AnePIE,
  Buttons, ExtCtrls;

Type
  TIsParam = class(TObject)
    IsParam : boolean;
  end;

  TfrmTree = class(TForm)
    tvLayers: TTreeView;
    ImageList1: TImageList;
    Panel1: TPanel;
    edValue: TEdit;
    Label3: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    procedure tvLayersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SetImageIndex(Node: TTreeNode);
    procedure SetParentImageIndex(Node: TTreeNode);
    procedure SetChildIndexes(Node: TTreeNode);
    procedure Moved(var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    procedure GetData;
    { Public declarations }
  end;

var
  frmTree: TfrmTree;

implementation

uses ANECB, OptionsUnit, UtilityFunctions;

{$R *.DFM}

procedure TfrmTree.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmTree.SetParentImageIndex(Node : TTreeNode);
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

procedure TfrmTree.SetChildIndexes(Node : TTreeNode);
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

procedure TfrmTree.SetImageIndex(Node : TTreeNode);
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

procedure TfrmTree.tvLayersMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if tvLayers.Selected <> nil then
  begin
    if htOnIcon in tvLayers.GetHitTestInfoAt(X,Y) then
    begin
      SetImageIndex(tvLayers.Selected);
      tvLayers.Invalidate;
    end;
  end;
end;

procedure TfrmTree.GetData;
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
  Lock : string;
  LastGroupNode : TTreeNode;
  IsParam : TIsParam;
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
          IsParam := TIsParam.Create;
          IsParam.IsParam := False;
          LastNode := tvLayers.Items.AddObject(LastGroupNode,
            LayerStringList[LayerIndex], IsParam);
          LastGroupNode := LastNode;
        end
        else
        begin
          if LastGroupNode = nil then
          begin
            IsParam := TIsParam.Create;
            IsParam.IsParam := False;
            LastNode := tvLayers.Items.AddObject(LastNode,
              LayerStringList[LayerIndex], IsParam);
          end
          else
          begin
            IsParam := TIsParam.Create;
            IsParam.IsParam := False;
            LastNode := tvLayers.Items.AddChildObject(LastGroupNode,
              LayerStringList[LayerIndex], IsParam);
          end;
        end;

        if LayerType in [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
          pieGridLayer,pieDomainLayer] then
        begin
          Layer.GetParameterNames(CurrentModelHandle,ParameterList);
          for ParameterIndex := 0 to ParameterList.Count -1 do
          begin
            Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
              ParameterList[ParameterIndex], CurrentModelHandle);
            try
              Lock := Parameter.Lock[CurrentModelHandle];
              if Pos('Lock Def Val',Lock) = 0 then
              begin
                IsParam := TIsParam.Create;
                IsParam.IsParam := True;
                tvLayers.Items.AddChildObject(LastNode,
                  ParameterList[ParameterIndex],IsParam);
              end;
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

procedure TfrmTree.BitBtn1Click(Sender: TObject);
var
//  LayerIndex : integer;
  LayerNode : TTreeNode;
  Layer : TLayerOptions;
  ParameterNode : TTreeNode;
  Parameter : TParameterOptions;
  IsParam : TIsParam;
begin
  if edValue.Text = '' then
  begin
    If MessageDlg('The expression you are trying to set is blank.  Are you '
      + 'sure you want to do this?', mtWarning, [mbYes, mbNo, mbCancel], 0)
      <> mrYes then
    begin
      Exit;
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
          Parameter.Expr[CurrentModelHandle] := edValue.Text;
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

procedure TfrmTree.FormCreate(Sender: TObject);
var
  DllDirectory : String;
begin
  inherited;
  if GetDllDirectory(GetDLLName, DllDirectory) then
  begin
    HelpFile := DllDirectory + '\' + HelpFile;
  end;
end;

end.
