unit frmDependsOnUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, ComCtrls, AnePIE, ExtCtrls, Buttons;

type
  TfrmDependsOn = class(TArgusForm)
    Panel8: TPanel;
    BitBtn1: TBitBtn;
    Panel9: TPanel;
    Panel1: TPanel;
    tvLayerStructure: TTreeView;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Splitter2: TSplitter;
    Panel4: TPanel;
    Panel6: TPanel;
    lvDependents: TListView;
    Panel5: TPanel;
    Panel7: TPanel;
    reExpression: TRichEdit;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure lvDependentsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure tvLayerStructureChange(Sender: TObject; Node: TTreeNode);
    procedure tvLayerStructureCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvDependentsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormResize(Sender: TObject);
  private
    LayerParameter: TStringList;
    LowerCaseExpressions: TStringList;
    Expressions: TStringList;
    SelectedLayer: string;
    SelectedNode: TTreeNode;
    SelectedItem: TListItem;
    { Private declarations }
  public
    procedure GetData;
    { Public declarations }
  end;

procedure GShowLayerDependecy(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;

var
  frmDependsOn: TfrmDependsOn;

implementation

uses UtilityFunctions, OptionsUnit;

{$R *.DFM}

procedure TfrmDependsOn.FormCreate(Sender: TObject);
var
  DllDirectory: string;
begin
  inherited;
  if GetDllDirectory(GetDLLName, DllDirectory) then
  begin
    HelpFile := DllDirectory + '\' + HelpFile;
  end;
  LayerParameter := TStringList.Create;
  LowerCaseExpressions := TStringList.Create;
  Expressions := TStringList.Create;
end;

procedure TfrmDependsOn.FormDestroy(Sender: TObject);
begin
  LayerParameter.Free;
  LowerCaseExpressions.Free;
  Expressions.Free;
  inherited;
end;

procedure TfrmDependsOn.GetData;
var
  ProjectOptions: TProjectOptions;
  Layers: TStringList;
  LayerIndex: integer;
  LayerName: string;
  Layer: TLayerOptions;
  LayerType: TPIELayerType;
  PriorGroupLayer: TTreeNode;
  PriorLayer: TTreeNode;
  Parameters: TStringList;
  ParameterIndex: ANE_INT32;
  Parameter: TParameterOptions;
  Expression: string;
begin
  PriorGroupLayer := nil;
  PriorLayer := nil;
  ProjectOptions := TProjectOptions.Create;
  Layers := TStringList.Create;
  Parameters := TStringList.Create;
  try
    // Get the layers
    ProjectOptions.LayerNames(CurrentModelHandle, [pieAnyLayer], Layers);
    // add a tree node for each layer and update the list of
    // expressions and Layer.Parameter names.
    for LayerIndex := 0 to Layers.Count - 1 do
    begin
      LayerName := Layers[LayerIndex];
      Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
      try
        // Create Tree node
        LayerType := Layer.LayerType[CurrentModelHandle];
        if LayerType = pieGroupLayer then
        begin
          PriorGroupLayer := tvLayerStructure.Items.Add(PriorGroupLayer,
            LayerName);
        end
        else
        begin
          if PriorGroupLayer = nil then
          begin
            PriorLayer := tvLayerStructure.Items.Add(PriorLayer, LayerName);
          end
          else
          begin
            PriorLayer := tvLayerStructure.Items.AddChild(PriorGroupLayer,
              LayerName);
          end;
        end;

        // Get Parameters;
        Layer.GetParameterNames(CurrentModelHandle, Parameters);
        for ParameterIndex := 0 to Parameters.Count - 1 do
        begin
          tvLayerStructure.Items.AddChild(PriorLayer,
            Parameters[ParameterIndex]);
          Parameter := TParameterOptions.Create(Layer.LayerHandle,
            ParameterIndex);
          try
            Expression := Parameter.Expr[CurrentModelHandle];
            // Update the lists.
            LayerParameter.Add(LayerName + '.' + Parameters[ParameterIndex]);
            Expressions.Add(Expression);
            LowerCaseExpressions.Add(LowerCase(Expression));
          finally
            Parameter.Free;
          end;
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;
  finally
    ProjectOptions.Free;
    Layers.Free;
    Parameters.Free;
  end;
end;

procedure TfrmDependsOn.lvDependentsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  Expression: string;
  SelLength: integer;
  CharIndex: integer;
  TestString: string;
begin
  inherited;
  if Selected then
  begin
    SelectedItem := Item;
    reExpression.Lines.Clear;
    reExpression.WordWrap := False;
    Expression := Item.SubItems[0];
    reExpression.Lines.Add(Expression);
    Expression := LowerCase(Expression);
    SelLength := Length(SelectedLayer);
    for CharIndex := Length(Expression)-SelLength+1 downto 1 do
    begin
      TestString := copy(Expression, CharIndex, SelLength);
      if TestString = SelectedLayer then
      begin
        reExpression.SelStart := CharIndex - 1;
        if Copy(Expression,CharIndex+SelLength,1) = '.' then
        begin
          reExpression.SelLength := SelLength+1;
        end
        else
        begin
          reExpression.SelLength := SelLength;
        end;
        reExpression.SelAttributes.Style := reExpression.SelAttributes.Style +
          [fsBold];
      end;
    end;
    reExpression.WordWrap := True;
  end
  else
  begin
    SelectedItem := nil;
  end;
  lvDependents.Invalidate;
end;

procedure GShowLayerDependecy(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;
begin
  try
    Application.CreateForm(TfrmDependsOn, frmDependsOn);
    try
      frmDependsOn.CurrentModelHandle := aneHandle;
      frmDependsOn.GetData;
      frmDependsOn.ShowModal;
    finally
      frmDependsOn.Free;
    end;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmDependsOn.tvLayerStructureChange(Sender: TObject;
  Node: TTreeNode);
var
  Index: integer;
  Expression: string;
  Item, FirstItem: TListItem;
begin
  inherited;
  SelectedNode := Node;
  reExpression.Lines.Clear;
  lvDependents.Items.Clear;
  if Node <> nil then
  begin
    FirstItem := nil;
    SelectedLayer := LowerCase(Node.Text);
    for Index := 0 to LowerCaseExpressions.Count - 1 do
    begin
      Expression := LowerCaseExpressions[Index];
      if Pos(SelectedLayer, Expression) > 0 then
      begin
        Item := lvDependents.Items.Add;
        Item.Caption := LayerParameter[Index];
        Item.SubItems.Add(Expressions[Index]);
        if FirstItem = nil then
        begin
          FirstItem := Item;
        end;
      end;
    end;
    if FirstItem <> nil then
    begin
      lvDependentsSelectItem(lvDependents, FirstItem, True);
    end;
  end;
end;

procedure TfrmDependsOn.tvLayerStructureCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  ARect: TRect;
begin
  inherited;
  if (Node = SelectedNode) then
  begin
    DefaultDraw := False;
    ARect := Node.DisplayRect(true);
    tvLayerStructure.Canvas.Brush.Color := clHighlight;
    tvLayerStructure.Canvas.Font.Color := clHighlightText;
    tvLayerStructure.Canvas.TextRect(ARect, ARect.Left + 2, ARect.Top,
      Node.Text);
  end;
end;

procedure TfrmDependsOn.lvDependentsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  ARect: TRect;
begin
  inherited;
  if (Item = SelectedItem) then
  begin
    DefaultDraw := False;
    ARect := Item.DisplayRect(drLabel);
    lvDependents.Canvas.Brush.Color := clHighlight;
    lvDependents.Canvas.Font.Color := clHighlightText;
    lvDependents.Canvas.TextRect(ARect, ARect.Left + 2, ARect.Top,
      Item.Caption);
  end;

end;

procedure TfrmDependsOn.FormResize(Sender: TObject);
begin
  inherited;
  if SelectedItem  <> nil then
  begin
    lvDependentsSelectItem(lvDependents, SelectedItem, True);
  end;
end;

end.

