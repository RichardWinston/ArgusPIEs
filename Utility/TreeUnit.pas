unit TreeUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ImgList, StdCtrls, AnePIE, Buttons, ExtCtrls, VirtualTrees;

type

  PLayerReference = ^TLayerReference;
  TLayerReference = record
    Name: string;
    AnObject: TObject;
    IsLayer: boolean;
  end;

  TfrmTree = class(TForm)
    Panel1: TPanel;
    edValue: TEdit;
    Label3: TLabel;
    BitBtn2: TBitBtn;
    btnOK: TBitBtn;
    BitBtn3: TBitBtn;
    btnAbout: TButton;
    vstLayers: TVirtualStringTree;
    btnApply: TButton;
    btnClear: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vstLayersGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure btnClearClick(Sender: TObject);
  private
    procedure GroupParamNames(const InputParmList, OutputParamList:TStringList);
    procedure Moved(var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Private declarations }
  public
    CurrentModelHandle: ANE_PTR;
    procedure GetData;
    { Public declarations }
  end;

var
  frmTree: TfrmTree;

implementation

uses ANECB, OptionsUnit, UtilityFunctions, frmAboutUnit;

{$R *.DFM}

procedure TfrmTree.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmTree.GroupParamNames(const InputParmList, OutputParamList:TStringList);
  function ExtractRoot(const AName: string): string;
  begin
    result := AName;
    while result[Length(result)] in
      ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] do
    begin
      result := Copy(result, 1, Length(result)-1);
    end;
  end;
var
  Index: integer;
  AName: string;
  ARoot: string;
  RootIndex: integer;
  SubList: TStringList;
begin
  // On input
  //   InputParmList is a list of parameter names
  // On output
  //   OutputParamList holds a list of parameter roots each of which
  //   is associated with a TStringList in the Objects property of
  //   OutputParamList that holds a list of the parameter names that have
  //   that root
  Assert(OutputParamList.Count = 0);
  for Index := 0 to InputParmList.Count -1 do
  begin
    AName := InputParmList[Index];
    ARoot := ExtractRoot(AName);
    RootIndex := OutputParamList.IndexOf(ARoot);
    if RootIndex >= 0 then
    begin
      SubList := OutputParamList.Objects[RootIndex] as TStringList;
    end
    else
    begin
      SubList := TStringList.Create;
      OutputParamList.AddObject(ARoot, SubList);
    end;
    SubList.Add(AName);
  end;
end;

procedure TfrmTree.GetData;
var
  LayerStringList: TStringList;
  Project: TProjectOptions;
  LastNode: PVirtualNode;
  ParamNode: PVirtualNode;
  LastParamGroupNode: PVirtualNode;
  LayerIndex: integer;
  ParameterList: TStringList;
  Layer: TLayerOptions;
  ParameterIndex: integer;
  LayerType: TPIELayerType;
  Parameter: TParameterOptions;
  Lock: string;
  LastGroupNode: PVirtualNode;
  AReference: PLayerReference;
  ParameterUsed: boolean;
  ParameterRoots: TStringList;
  SortedParams: TStringList;
  RootIndex: integer;
begin

  LayerStringList := TStringList.Create;
  ParameterList := TStringList.Create;
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieAnyLayer], LayerStringList);
    vstLayers.RootNodeCount := 0;
    vstLayers.NodeDataSize := SizeOf(TLayerReference);
    LastNode := nil;
    LastGroupNode := nil;
    for LayerIndex := 0 to LayerStringList.Count - 1 do
    begin
      Layer := TLayerOptions.CreateWithName(LayerStringList[LayerIndex],
        CurrentModelHandle);
      //      try
      LayerType := Layer.LayerType[CurrentModelHandle];
      if LayerType = pieGroupLayer then
      begin
        vstLayers.RootNodeCount := vstLayers.RootNodeCount + 1;
        if LastNode = nil then
        begin
          // This is the very first layer
          LastNode := vstLayers.GetFirst;
        end
        else
        begin
          if LastGroupNode = nil then
          begin
            // this is the first group layer
            LastNode := vstLayers.GetNextSibling(LastNode);
          end
          else
          begin
            // this is a sibling of the previous group layer
            LastNode := vstLayers.GetNextSibling(LastGroupNode);
          end;
        end;
        LastNode.CheckType := ctTriStateCheckBox;

        AReference := vstLayers.GetNodeData(LastNode);
        LastGroupNode := LastNode;
      end
      else
      begin
        // This is a normal layer rather than a group layer.
        if LastGroupNode = nil then
        begin
          // there is no prior group layer
          vstLayers.RootNodeCount := vstLayers.RootNodeCount + 1;
          if LastNode = nil then
          begin
            // this is the very first layer
            LastNode := vstLayers.GetFirst;
          end
          else
          begin
            // this is a sibling of the previous normal layer
            LastNode := vstLayers.GetNextSibling(LastNode);
          end;

          LastNode.CheckType := ctTriStateCheckBox;

          AReference := vstLayers.GetNodeData(LastNode);
        end
        else
        begin
          // This layer is beneath a group layer
          LastNode := vstLayers.AddChild(LastGroupNode, nil);
          AReference := vstLayers.GetNodeData(LastNode);
          LastNode.CheckType := ctTriStateCheckBox;
        end;
      end;
      AReference^.Name := LayerStringList[LayerIndex];
      AReference^.AnObject := Layer;
      AReference^.IsLayer := True;

      if LayerType in [pieTriMeshLayer, pieQuadMeshLayer, pieInformationLayer,
        pieGridLayer, pieDomainLayer] then
      begin
        Layer.GetParameterNames(CurrentModelHandle, ParameterList);
        ParameterRoots := TStringList.Create;
        try
          GroupParamNames(ParameterList, ParameterRoots);
          for RootIndex := 0 to ParameterRoots.Count -1 do
          begin
            SortedParams := ParameterRoots.Objects[RootIndex] as TStringList;
            if SortedParams.Count = 1 then
            begin
              ParameterUsed := False;
              Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
                SortedParams[0], CurrentModelHandle);
              try
                Lock := Parameter.Lock[CurrentModelHandle];
                if Pos('Lock Def Val', Lock) = 0 then
                begin

                  ParameterUsed := True;

                  ParamNode := vstLayers.AddChild(LastNode, nil);
                  ParamNode.CheckType := ctCheckBox;
                  AReference := vstLayers.GetNodeData(ParamNode);
                  AReference^.Name := SortedParams[0];
                  AReference^.AnObject := Parameter;
                  AReference^.IsLayer := false;
                end;
              finally
                if not ParameterUsed then
                begin
                  Parameter.Free;
                end;
              end;
            end
            else
            begin
              LastParamGroupNode := nil;
              for ParameterIndex := 0 to SortedParams.Count -1 do
              begin
                ParameterUsed := False;
                Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
                  SortedParams[ParameterIndex], CurrentModelHandle);
                try
                  Lock := Parameter.Lock[CurrentModelHandle];
                  if Pos('Lock Def Val', Lock) = 0 then
                  begin

                    ParameterUsed := True;

                    if LastParamGroupNode = nil then
                    begin
                      LastParamGroupNode := vstLayers.AddChild(LastNode, nil);
                      LastParamGroupNode.CheckType := ctTriStateCheckBox;
                      AReference := vstLayers.GetNodeData(LastParamGroupNode);
                      AReference^.Name := ParameterRoots[RootIndex] + '[i]';
                      AReference^.AnObject := nil;
                      AReference^.IsLayer := True;
                    end;


                    ParamNode := vstLayers.AddChild(LastParamGroupNode, nil);
                    ParamNode.CheckType := ctCheckBox;
                    AReference := vstLayers.GetNodeData(ParamNode);
                    AReference^.Name := SortedParams[ParameterIndex];
                    AReference^.AnObject := Parameter;
                    AReference^.IsLayer := false;
                  end;
                finally
                  if not ParameterUsed then
                  begin
                    Parameter.Free;
                  end;
                end;
              end;

            end;

          end;


          {for ParameterIndex := 0 to ParameterList.Count - 1 do
          begin
            ParameterUsed := False;
            Parameter := TParameterOptions.CreateWithNameAndLayer(Layer,
              ParameterList[ParameterIndex], CurrentModelHandle);
            try
              Lock := Parameter.Lock[CurrentModelHandle];
              if Pos('Lock Def Val', Lock) = 0 then
              begin

                ParameterUsed := True;

                ParamNode := vstLayers.AddChild(LastNode, nil);
                ParamNode.CheckType := ctCheckBox;
                AReference := vstLayers.GetNodeData(ParamNode);
                AReference^.Name := ParameterList[ParameterIndex];
                AReference^.AnObject := Parameter;
                AReference^.IsLayer := false;
              end;
            finally
              if not ParameterUsed then
              begin
                Parameter.Free;
              end;
            end;
          end;   }
        finally
          for ParameterIndex := 0 to ParameterRoots.Count -1 do
          begin
            ParameterRoots.Objects[ParameterIndex].Free;
          end;

          ParameterRoots.Free;
        end;
      end;
    end;
  finally
    LayerStringList.Free;
    ParameterList.Free;
    Project.Free;
  end;

end;

procedure TfrmTree.btnOKClick(Sender: TObject);
var
  ParameterNode: PVirtualNode;
  Parameter: TParameterOptions;
  ARef: PLayerReference;
begin
  if edValue.Text = '' then
  begin
    if MessageDlg('The expression you are trying to set is blank.  Are you '
      + 'sure you want to do this?', mtWarning, [mbYes, mbNo, mbCancel], 0)
      <> mrYes then
    begin
      Exit;
    end;
  end;

  ParameterNode := vstLayers.GetFirst;
  while ParameterNode <> nil do
  begin

    ARef := vstLayers.GetNodeData(ParameterNode);

    if not ARef^.IsLayer and
      (vstLayers.CheckState[ParameterNode] = csCheckedNormal) then
    begin
      Parameter := ARef^.AnObject as TParameterOptions;
      Parameter.Expr[CurrentModelHandle] := edValue.Text;
    end;
    ParameterNode := vstLayers.GetNext(ParameterNode);
  end;

  MessageDlg('The expressions have been set.', mtInformation, [mbOK], 0);
end;

procedure TfrmTree.FormCreate(Sender: TObject);
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

procedure TfrmTree.FormResize(Sender: TObject);
begin
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmTree.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

procedure TfrmTree.FormDestroy(Sender: TObject);
var
  Node: PVirtualNode;
  ARef: PLayerReference;
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

procedure TfrmTree.vstLayersGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PLayerReference;

begin
  // A handler for the OnGetText event is always needed as it provides
  // the tree with the string data to display.
  // Note that we are always using WideString.
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data^.Name;

end;

procedure TfrmTree.btnClearClick(Sender: TObject);
var
  ParameterNode: PVirtualNode;
begin
  ParameterNode := vstLayers.GetFirst;
  while ParameterNode <> nil do
  begin
    vstLayers.CheckState[ParameterNode] := csUncheckedNormal;
    ParameterNode := vstLayers.GetNext(ParameterNode);
  end;
end;

end.

