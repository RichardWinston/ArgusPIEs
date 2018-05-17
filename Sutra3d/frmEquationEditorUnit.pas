unit frmEquationEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, JvExStdCtrls, RichEdit, JvRichEdit, ComCtrls, ExtCtrls,
  JvExExtCtrls, JvNetscapeSplitter, Buttons, RbwParser;

type
  TTreeNodeTextStorage = class(TObject)
  public
    OpenText: string;
    ClosedText: string;
  end;

  TfrmEquationEditor = class(TArgusForm)
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    btnHelp: TBitBtn;
    pnlMain: TPanel;
    JvNetscapeSplitter1: TJvNetscapeSplitter;
    pnlButtons: TPanel;
    gbNumbers: TGroupBox;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    btn6: TButton;
    btn5: TButton;
    btn4: TButton;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn0: TButton;
    btnE: TButton;
    btnDecimal: TButton;
    gbOperators: TGroupBox;
    btnOpenParen: TButton;
    btnCloseParen: TButton;
    btnDivide: TButton;
    btnMultiply: TButton;
    btnPlus: TButton;
    btnMinus: TButton;
    btnPower: TButton;
    btnDoubleAsterisk: TButton;
    tvFormulaDiagram: TTreeView;
    jreFormula: TJvRichEdit;
    pnlRight: TPanel;
    pnlLabelItemTree: TPanel;
    tvItems: TTreeView;
    Splitter: TSplitter;
    rbFormulaParser: TRbwParser;
    Timer: TTimer;
    procedure buttonClick(Sender: TObject);
    procedure jreFormulaChange(Sender: TObject);
    procedure jreFormulaDblClick(Sender: TObject);
    procedure TimerSetSelection(Sender: TObject);
    procedure tvFormulaDiagramCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvFormulaDiagramExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvItemsDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure FormShow(Sender: TObject);
    procedure tvItemsChange(Sender: TObject; Node: TTreeNode);
    procedure jreFormulaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure jreFormulaSelectionChange(Sender: TObject);
  private
    // @name specifies the length of the text that
    // should be selected in @link(jreFormulaDblClick).
    FNewSelectionLength: integer;
    // @name specifies the start of the text that
    // should be selected in @link(jreFormulaDblClick).
    FNewSelectionStart: integer;
    // @name is set to the previous button that was clicked.  It is used
    // to help determine whether there should be spaces before the
    // the text specified by the button.
    FLastButton: TButton;
    FDiagramObjectStorage: TList;
    FClickSelectionStart: integer;
    FSelectedNode: TTreeNode;
    FResultSet: boolean;
    FDataSetGroupName: string;
    FFunctions: TTreeNode;
    FUpdating: Boolean;
    FSetColor: Boolean;
    procedure InsertText(const NewText: string);
    function GetFormula: string;
    procedure SetFormula(const Value: string);
    procedure DiagramFormula;
    procedure MatchEndingParen(PriorSelection: TCharRange);
    procedure MatchStartingParen(PriorSelection: TCharRange);
    { Private declarations }
  public
    // Name used in the TTreeNode that holds TCustomVariables in @link(tvItems).
    // By default, it is 'Data Sets'.
    property DataSetGroupName: string read FDataSetGroupName
      write FDataSetGroupName;
    // use @name to read or set the formula.
    property Formula: string read GetFormula write SetFormula;
    { Public declarations }
    // @name is set to true if the formula has been successfully changed.
    property ResultSet: boolean read FResultSet;
    // @name creates the nodes in @link(tvItems).
    procedure UpdateTreeList;
  end;

var
  frmEquationEditor: TfrmEquationEditor;

implementation

{$R *.DFM}

uses contnrs, UcodeParameterFunctions, UcodeParser, IntListUnit;

function PosEx(const SubStr, S: string; Offset: Integer = 1): Integer;
var
  Index: integer;
  SubLength: integer;
begin
  result := 0;
  SubLength := Length(SubStr);
  for Index := Offset to Length(S) - SubLength+1 do
  begin
    if Copy(S, Index, SubLength) = SubStr then
    begin
      result := Index;
      Exit;
    end;
  end;
end;

procedure TfrmEquationEditor.buttonClick(Sender: TObject);
var
  //  AString: string;
  NewText: string;
  //  Start, sLength: integer;
  UseSpaces: boolean;
  Index: integer;
  //  Sel: TMemoSelection;
  SomeButtons: array[0..15] of TButton;
begin
  SomeButtons[0] := btn1;
  SomeButtons[1] := btn2;
  SomeButtons[2] := btn3;
  SomeButtons[3] := btn4;
  SomeButtons[4] := btn5;
  SomeButtons[5] := btn6;
  SomeButtons[6] := btn7;
  SomeButtons[7] := btn8;
  SomeButtons[8] := btn9;
  SomeButtons[9] := btn0;
  SomeButtons[10] := btnDecimal;
  SomeButtons[11] := btnOpenParen;
  SomeButtons[12] := btnCloseParen;
  SomeButtons[13] := btnDoubleAsterisk;
  SomeButtons[14] := btnPower;
  SomeButtons[15] := btnE;
  UseSpaces := True;
  for Index := Low(SomeButtons) to High(SomeButtons) do
  begin
    if Sender = SomeButtons[Index] then
    begin
      UseSpaces := False;
      break;
    end;
  end;

  if (FLastButton = btnE) and ((Sender = btnPlus) or (Sender = btnMinus)) then
  begin
    UseSpaces := False;
  end;

  if UseSpaces then
  begin
    NewText := ' ' + (Sender as TButton).Caption + ' ';
  end
  else
  begin
    NewText := (Sender as TButton).Caption;
  end;

  InsertText(NewText);
  FLastButton := Sender as TButton;
end;

function TfrmEquationEditor.GetFormula: string;
var
  Index: integer;
begin
  result := '';
  for Index := 0 to jreFormula.Lines.Count - 1 do
  begin
    result := result + jreFormula.Lines[Index];
    if (Length(result) > 0) and (result[Length(result)] <> ' ') then
    begin
      result := result + ' ';
    end;
  end;
  result := Trim(Result);
end;

procedure TfrmEquationEditor.InsertText(const NewText: string);
const
{$IFDEF LINUX}
  BreakChar = [#10];
{$ELSE}
  BreakChar = [#10,#13];
{$ENDIF}
var
  AString: string;
  Start, sLength, TempStop: integer;
  Index: integer;
  Position: integer;
  NewExpression: string;
  TextToSelect: string;
  NewStart: integer;
  OldCount: integer;
  TempString: string;
  FormulaText: string;
  SelLength: integer;
begin
  try
    SelLength := jreFormula.SelLength;
    if SelLength > 0 then
    begin
      FormulaText := jreFormula.Lines.Text;
      Start := jreFormula.SelStart + 1;
      Delete(FormulaText, Start, SelLength);
      Insert(NewText, FormulaText, Start);
      jreFormula.Text := FormulaText;
      {Sel := jreFormula.Selection;
      if Sel.Line2 = Sel.Line1 then
      begin
        AString := jreFormula.Lines[Sel.Line1];
        Delete(AString, Sel.Col1 + 1, Sel.Col2 - Sel.Col1);
        Insert(NewText, AString, Sel.Col1 + 1);
        jreFormula.Lines[Sel.Line1] := AString;
      end
      else
      begin
        jreFormula.Lines[Sel.Line2] := Copy(jreFormula.Lines[Sel.Line2],
          Sel.Col2, MAXINT);
        for Index := Sel.Line2 - 1 downto Sel.Line1 + 1 do
        begin
          jreFormula.Lines.Delete(Index);
        end;
        jreFormula.Lines[Sel.Line1] := Copy(jreFormula.Lines[Sel.Line1],
          1, Sel.Col1) + NewText;
      end;   }
      // eliminate line breaks.
      Formula := Formula;

      Position := Pos('(', NewText);
      if (Position >= 1) and (NewText <> '(') then
      begin
        TextToSelect := '';
        sLength := 0;
        for Index := Position + 1 to Length(NewText) do
        begin
          if (NewText[Index] in [' ', ',', ')']) then
          begin
            sLength := Index - Position - 1;
            TextToSelect := Copy(NewText, Position + 1, sLength);
            break;
          end;
        end;
        If TextToSelect <> '' then
        begin
          NewExpression := jreFormula.Lines.Text;
          Start := Position + Start {- Sel.Line1*Length(sLineBreak)};
          Start := PosEx(TextToSelect, NewExpression, Start) -1 {+ Sel.Line1*Length(sLineBreak)};
//          EndPos := Pos(sLineBreak, NewExpression);
{          while(EndPos < Start) and
            (PosEx(sLineBreak, NewExpression, EndPos) > 0) do
          begin
            Start := Start + Length(sLineBreak);
            EndPos := PosEx(sLineBreak, NewExpression, EndPos);
          end;  }

          jreFormula.SelStart := Start;
          jreFormula.SelLength := sLength;

          While(jreFormula.SelText <> TextToSelect)
            and (jreFormula.SelStart + sLength + 1 < Length(NewExpression)) do
          begin
            NewStart := jreFormula.SelStart + 1;
            jreFormula.SelStart := NewStart;
            jreFormula.SelLength := sLength;
            if jreFormula.SelStart <> NewStart then
            begin
              NewStart := NewStart + 1;
              jreFormula.SelStart := NewStart;
              jreFormula.SelLength := sLength;
              if jreFormula.SelStart <> NewStart then
              begin
                break
              end;
            end;
          end
        end;
      end
      else
      begin
        jreFormula.SelStart := Start - 1 + Length(NewText);
        jreFormula.SelLength := 0;
      end;

    end
    else
    begin
      if jreFormula.Lines.Count = 0 then
      begin
        jreFormula.Lines.Add(NewText);
        Position := Pos('(', NewText);
        if Position >= 1 then
        begin
          Start := Position + 2;
          sLength := Length(NewText);
          for Index := Start to Length(NewText) do
          begin
            if NewText[Index] in [' ', ',', ')'] then
            begin
              sLength := Index - Start + 1;
              break;
            end;

          end;
          jreFormula.SelStart := Start;
          jreFormula.SelLength := sLength;
        end
        else
        begin
          jreFormula.SelStart := Length(NewText);
        end;
      end
      else
      begin
//        AString := '';
        OldCount := jreFormula.Lines.Count;
//        for Index := 0 to jreFormula.Lines.Count -1 do
//        begin
//          AString := AString + jreFormula.Lines[Index] + sLineBreak;
//        end;

        AString := jreFormula.Lines.Text;

        Start := jreFormula.SelStart + 1;
        sLength := jreFormula.SelLength;
        Delete(AString, Start, sLength);
        Insert(NewText, AString, Start);
        TempString := AString;
        TempStop := Start + Length(NewText) -1;
//        AString := StringReplace(AString, sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
        jreFormula.Lines.Text := AString;
//        Formula := AString;

        Position := Pos('(', NewText);
        if (Position >= 1) and (NewText <> '(') then
        begin
          Start := Position + Start - 1;
          sLength := 0;
          for Index := Start to Start + Length(NewText) do
          begin
            if (Index + 1 <= Length(AString))
              and (AString[Index + 1] in [' ', ',', ')']) then
            begin
              sLength := Index - Start;
              TextToSelect := Copy(NewText,Position+1,sLength);
              break;
            end;
          end;
          jreFormula.SelStart := Start;
          jreFormula.SelLength := sLength;

          NewExpression := jreFormula.Lines.Text;
          While(jreFormula.SelText <> TextToSelect)
            and (jreFormula.SelStart + sLength + 1 < Length(NewExpression)) do
          begin
            NewStart := jreFormula.SelStart + 1;
            jreFormula.SelStart := NewStart;
            jreFormula.SelLength := sLength;
            if jreFormula.SelStart <> NewStart then
            begin
              NewStart := NewStart + 1;
              jreFormula.SelStart := NewStart;
              jreFormula.SelLength := sLength;
              if jreFormula.SelStart <> NewStart then
              begin
                break
              end;
            end;
          end
        end
        else
        begin
          jreFormula.SelStart := Start - 1 + Length(NewText);
          if (jreFormula.Lines.Count <> OldCount) then
          begin
            // find where the new text ends and place the cursor just after it.
            NewStart := -1;
            for Index := 1 to TempStop do
            begin
              // skip line breaks in the replacement string.
              if not (TempString[Index] in BreakChar) then
              begin
                NewStart := NewStart + 1;
                jreFormula.SelStart := NewStart;
                jreFormula.SelLength := 1;
                // skip line breaks in jreFormula
                if jreFormula.SelStart <> NewStart then
                begin
                  NewStart := NewStart + 1;
                  jreFormula.SelStart := NewStart;
                  jreFormula.SelLength := 1;
                end;
                // skip line breaks in jreFormula
                if (TempString[Index] <> jreFormula.SelText) then
                begin
                  NewStart := NewStart + 1;
                  jreFormula.SelStart := NewStart;
                  jreFormula.SelLength := 1;
                  // skip line breaks in jreFormula
                  if jreFormula.SelStart <> NewStart then
                  begin
                    NewStart := NewStart + 1;
                    jreFormula.SelStart := NewStart;
                    jreFormula.SelLength := 1;
                  end;
                end;
                Assert (TempString[Index] = jreFormula.SelText);
              end;
            end;
            jreFormula.SelStart := jreFormula.SelStart+1;
          end;
        end;
      end;
    end;
  finally
    FocusControl(jreFormula);
  end;
end;

procedure TfrmEquationEditor.SetFormula(const Value: string);
begin
  jreFormula.Lines.Clear;
  jreFormula.Lines.Add(Value);
  jreFormula.SelectAll;
end;

procedure TfrmEquationEditor.jreFormulaChange(Sender: TObject);
begin
  btnOK.Enabled := True;
  DiagramFormula;
end;

procedure TfrmEquationEditor.DiagramFormula;
const
  TAB_CHAR = #9;
var
  AFormula: string;
  DiagramList: TStringList;
  Index: Integer;
  TabCount: integer;
  NodeStack: TList;
  CharIndex: integer;
  Line: string;
  FunctionName: string;
  FunctionFormula: string;
  TabPosition: integer;
  Node: TTreeNode;
  NodeData: TTreeNodeTextStorage;
begin
  tvFormulaDiagram.Items.Clear;
  FDiagramObjectStorage.Clear;
  AFormula := Formula;
  try
    if rbFormulaParser.Compile(AFormula) >= 0 then
    begin
      DiagramList := TStringList.Create;
      try
        rbFormulaParser.CurrentExpression.Diagram(DiagramList);
        NodeStack := TList.Create;
        try
          for Index := 0 to DiagramList.Count - 1 do
          begin
            Line := DiagramList[Index];
            TabCount := 0;
            for CharIndex := 1 to Length(Line) do
            begin
              if Line[CharIndex] = TAB_CHAR then
              begin
                Inc(TabCount)
              end
              else
              begin
                break;
              end;
            end;
            Line := Copy(Line, TabCount+1, MaxInt);
            TabPosition := Pos(TAB_CHAR, Line);
            FunctionName := Copy(Line, 1, TabPosition-1);
            FunctionFormula := Copy(Line, TabPosition+1, MAXINT);
            if TabCount >= NodeStack.Count then
            begin
              if NodeStack.Count > 0 then
              begin
                Node := NodeStack[NodeStack.Count-1];
              end
              else
              begin
                Node := nil;
              end;
              Node := tvFormulaDiagram.Items.AddChild(Node, FunctionFormula);
              NodeStack.Add(Node);
            end
            else
            begin
              Node := NodeStack[TabCount];
              Node := tvFormulaDiagram.Items.Add(Node, FunctionFormula);
              NodeStack[TabCount] := Node;
              NodeStack.Count := TabCount+1;
            end;
            NodeData := TTreeNodeTextStorage.Create;
            FDiagramObjectStorage.Add(NodeData);
            NodeData.OpenText := FunctionName;
            NodeData.ClosedText := FunctionFormula;
            Node.Data := NodeData;
          end;
        finally
          NodeStack.Free;
        end;
      finally
        DiagramList.Free;
      end;
    end;
  except on E: ErbwParserError do
    begin
      // ignore
    end;
  end;
end;

procedure TfrmEquationEditor.jreFormulaDblClick(Sender: TObject);
type
  TBrace = (bNone, bStart, bStop);
const
  Separators: set of Char = [' ', ',', '(', ')', #10, #13, #9, '*', '/', '+',
  '-', '"'];
var
  LineNumber: integer;
  AString: string;
  Index: integer;
  Stop, Start: integer;
  function CurlyBrace: TBrace;
  var
    SelectedString: string;
    SelectedChar: char;
  begin
    result := bNone;
    SelectedString := Copy(AString, Start, 1);
    if Length(SelectedString) > 0 then
    begin
      SelectedChar := SelectedString[1];
      if SelectedChar = '{' then
      begin
        result := bStart;
      end
      else if SelectedChar = '}' then
      begin
        result := bStop;
      end;

    end;
  end;
begin
  inherited;
  if FClickSelectionStart >= 0 then
  begin
    AString := jreFormula.Lines.Text;
    Stop := Length(AString);
    Start := 1;

    case CurlyBrace of
      bNone:
        begin
          // Change stop so it represents the location of the first separator
          // after the selected position.
          for Index := FClickSelectionStart + 1 to Length(AString) + 1 do
          begin
            if Index <= Length(AString) then
            begin
              Stop := Index;
              if AString[Index] in Separators then
              begin
                break;
              end;
            end
            else
            begin
              Stop := Length(AString) + 1;
            end;
          end;
          // Change Start so it represents the first character
          // after the first separator before the selected position.
          for Index := FClickSelectionStart downto 1 do
          begin
            if Index <= Length(AString) then
            begin
              Start := Index;
              if AString[Index] in Separators then
              begin
                Start := Start + 1;
                break;
              end;
            end
            else
            begin
              Start := Length(AString);
            end;
          end;
        end;
      bStart:
        begin
          for Index := FClickSelectionStart + 1 to Length(AString) + 1 do
          begin
            // change Stop so that it represents the first
            // end curly brace after the selected position.
            if Index <= Length(AString) then
            begin
              Stop := Index;
              if AString[Index] = '}' then
              begin
                Stop := Stop + 1;
                break;
              end;
            end
            else
            begin
              Stop := Length(AString) + 1;
            end;
          end;
        end;
      bStop:
        begin
            // change Start so that it represents the first
            // start curly brace before the selected position.
          for Index := FClickSelectionStart downto 1 do
          begin
            if Index <= Length(AString) then
            begin
              Start := Index;
              if AString[Index] = '{' then
              begin
                break;
              end;
            end
            else
            begin
              Start := Length(AString);
            end;
          end;
        end;
    else Assert(False);
    end;

    LineNumber := 0;
    Index := PosEx(#13#10, AString, 1);
    while Index < Start do
    begin
      Inc(LineNumber);
      Index := PosEx(#13#10, AString, Index+2);
    end;
    Start := Start - LineNumber*2;
    Stop := Stop - LineNumber*2;

    // Set FNewSelectionStart and FNewSelectionLength for use in
    // TimerSetSelection.
    FNewSelectionStart := Start - 1;
    if Stop <> Start then
    begin
      FNewSelectionLength := Stop - Start;
    end
    else
    begin
      FNewSelectionLength := 1;
    end;
    // The selection can't be changed here so do it in TimerSetSelectionO.
    Timer.OnTimer := TimerSetSelection;
    Timer.Enabled := True;
  end;
end;

procedure TfrmEquationEditor.TimerSetSelection(Sender: TObject);
begin
  Timer.Enabled := False;
  jreFormula.SelStart := FNewSelectionStart;
  jreFormula.SelLength := FNewSelectionLength;
end;

procedure TfrmEquationEditor.tvFormulaDiagramCollapsed(Sender: TObject;
  Node: TTreeNode);
var
  NodeData: TTreeNodeTextStorage;
begin
  inherited;
  NodeData := Node.Data;
  Node.Text := NodeData.ClosedText;
end;

procedure TfrmEquationEditor.tvFormulaDiagramExpanded(Sender: TObject;
  Node: TTreeNode);
var
  NodeData: TTreeNodeTextStorage;
begin
  inherited;
  NodeData := Node.Data;
  Node.Text := NodeData.OpenText;
end;

procedure TfrmEquationEditor.tvItemsDblClick(Sender: TObject);
var
  AnObject: TObject;
  FClass: TFunctionClass;
  Value: TCustomValue;
  Prototype: string;
  SeparatorPos: integer;
begin
  inherited;
  Assert(FSelectedNode <> nil);
  AnObject := FSelectedNode.Data;
  if AnObject <> nil then
  begin
    if AnObject is TFunctionClass then
    begin
      FClass := FSelectedNode.Data;
      Prototype := FClass.Prototype;
      SeparatorPos := Pos('|', Prototype);
      while SeparatorPos > 0 do
      begin
        Prototype := Copy(Prototype, SeparatorPos + 1, MAXINT);
        SeparatorPos := Pos('|', Prototype);
      end;
      InsertText(Prototype);
    end
    else if AnObject is TCustomValue then
    begin
      Value := FSelectedNode.Data;
      InsertText(Value.Decompile);
    end;
  end;
end;

procedure TfrmEquationEditor.btnOKClick(Sender: TObject);
var
  AFormula: string;
begin
  inherited;
  AFormula := Formula;
  try
    if (AFormula = '') or (rbFormulaParser.Compile(AFormula) >= 0) then
    begin
      FResultSet := True;
    end;
    Close;
  except on E: ErbwParserError do
    begin
      btnOK.Enabled := False;
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmEquationEditor.FormCreate(Sender: TObject);
begin
  DataSetGroupName := 'Data Sets';

  Constraints.MinWidth := Width;
  pnlMain.Constraints.MinWidth := pnlMain.Width;
  pnlButtons.Constraints.MinWidth := pnlButtons.Width;

  FDiagramObjectStorage := TObjectList.Create;
  AdaptParserForUcode(rbFormulaParser);
end;

procedure TfrmEquationEditor.FormDestroy(Sender: TObject);
begin
  FDiagramObjectStorage.Free;
end;

procedure TfrmEquationEditor.UpdateTreeList;
var
  Index: integer;
  FClass: TFunctionClass;
  AVariable: TCustomValue;
  Prototype: string;
  ChildName: string;
  SeparatorPos: integer;
  ParentNode: TTreeNode;
  ChildNode: TTreeNode;
  FunctionNames: TStringList;
  Classifications: TStringList;
  Classification: string;
  RootNode: TTreeNode;
  ClassificationIndex: integer;
  FullClassificaton: string;
  ClassificationList: TStringList;
  FullClassificationList: TStringList;
  CIndex: Integer;
  Item: TSpecialImplementor;
  SortedVariables: TStringList;
begin
  FunctionNames := TStringList.Create;
  ClassificationList := TStringList.Create;
  FullClassificationList := TStringList.Create;
  try
//    ClassificationList.Delimiter := '|';
    FunctionNames.Sorted := True;
    FunctionNames.Duplicates := dupIgnore;
    for Index := 0 to OverloadedFunctionList.Count - 1 do
    begin
      FClass := OverloadedFunctionList[Index] as TFunctionClass;
      if not FClass.Hidden then
      begin
        FunctionNames.AddObject(FClass.Prototype, FClass);
      end;
    end;
    for Index := 0 to rbFormulaParser.SpecialImplementorList.Count - 1 do
    begin
      Item := rbFormulaParser.SpecialImplementorList[Index];
      FClass := Item.FunctionClass;
      if not FClass.Hidden then
      begin
        FunctionNames.AddObject(FClass.Prototype, FClass);
      end;
    end;
    for Index := 0 to rbFormulaParser.Functions.Count - 1 do
    begin
      FClass := rbFormulaParser.Functions.FunctionClass[Index];
      if not FClass.Hidden then
      begin
        FunctionNames.AddObject(FClass.Prototype, FClass);
      end;
    end;
    if rbFormulaParser.VariableCount > 0 then
    begin
      SortedVariables := TStringList.Create;
      try
        for Index := 0 to rbFormulaParser.VariableCount - 1 do
        begin
          AVariable := rbFormulaParser.Variables[Index];
          Classification := AVariable.Classification + '|' + AVariable.Name;
          SortedVariables.AddObject(Classification, AVariable);
        end;
        SortedVariables.Sort;
        Classifications := TStringList.Create;
        try
          for Index := 0 to SortedVariables.Count - 1 do
          begin
            RootNode := nil;
            AVariable := SortedVariables.Objects[Index] as TCustomValue;
            Classification := AVariable.Classification;
            FullClassificaton := Classification;
            FullClassificaton := StringReplace(FullClassificaton, ' ', '_', [rfReplaceAll]);
            ClassificationList.Text := StringReplace(FullClassificaton, '|', #13#10, [rfReplaceAll]);
            for CIndex := 0 to ClassificationList.Count - 1 do
            begin
              ClassificationList[CIndex] :=
                StringReplace(ClassificationList[CIndex], '_', ' ', [rfReplaceAll]);
            end;
            FullClassificationList.Clear;
            Classification := ClassificationList[0];
            FullClassificationList.Add(Classification);
            for CIndex := 1 to ClassificationList.Count - 1 do
            begin
              Classification := Classification + '|' + ClassificationList[CIndex];
              FullClassificationList.Add(Classification);
            end;

            for CIndex := 0 to ClassificationList.Count - 1 do
            begin
              FullClassificaton := FullClassificationList[CIndex];
              Classification := ClassificationList[CIndex];
              ClassificationIndex := Classifications.IndexOf(FullClassificaton);
              if ClassificationIndex < 0 then
              begin
                RootNode := tvItems.Items.AddChild(RootNode,Classification);
                Classifications.AddObject(FullClassificaton, RootNode)
              end
              else
              begin
                RootNode := Classifications.Objects[ClassificationIndex]
                  as TTreeNode;
              end;
            end;

            tvItems.Items.AddChildObject(RootNode, AVariable.Decompile, AVariable);
          end;
        finally
          Classifications.Free;
        end;
      finally
        SortedVariables.Free;
      end;
    end;
    FFunctions := tvItems.Items.Add(nil, 'Functions');
    for Index := 0 to FunctionNames.Count - 1 do
    begin
      ParentNode := FFunctions;
      FClass := FunctionNames.Objects[Index] as TFunctionClass;
      Prototype := FClass.Prototype;
      SeparatorPos := Pos('|', Prototype);
      while SeparatorPos > 0 do
      begin
        ChildName := Copy(Prototype, 1, SeparatorPos - 1);
        Prototype := Copy(Prototype, SeparatorPos + 1, MAXINT);
        ChildNode := ParentNode.getFirstChild;
        while ChildNode <> nil do
        begin
          if ChildNode.Text = ChildName then
          begin
            ParentNode := ChildNode;
            Break;
          end;
          ChildNode := ParentNode.GetNextChild(ChildNode);
        end;
        if ChildNode = nil then
        begin
          ParentNode := tvItems.Items.AddChild(ParentNode, ChildName);
        end;
        SeparatorPos := Pos('|', Prototype);
      end;

      tvItems.Items.AddChildObject(ParentNode, FClass.Name, FClass);
    end;
  finally
    FunctionNames.Free;
    ClassificationList.Free;
    FullClassificationList.Free;
  end;
end;

procedure TfrmEquationEditor.FormShow(Sender: TObject);
begin
  jreFormula.SetFocus;
end;

procedure TfrmEquationEditor.tvItemsChange(Sender: TObject;
  Node: TTreeNode);
begin
  inherited;
  FSelectedNode := Node;
end;

procedure TfrmEquationEditor.jreFormulaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FClickSelectionStart := jreFormula.SelStart;
end;

procedure TfrmEquationEditor.jreFormulaSelectionChange(Sender: TObject);
var
  PriorSelection: TCharRange;
  NewSelection: TCharRange;
  SelText: string;
begin
  if FUpdating then Exit;
  FUpdating := True;
  try
    PriorSelection := jreFormula.GetSelection;
    try
      if FSetColor then
      begin
        jreFormula.SetSelection(0, MAXINT, False);
        jreFormula.SelAttributes.BackColor := clWindow;
        jreFormula.SetSelection(PriorSelection.cpMin, PriorSelection.cpMax, False);
        FSetColor := False;
      end;

      NewSelection := PriorSelection;
      if NewSelection.cpMin = NewSelection.cpMax then
      begin
        Inc(NewSelection.cpMax);
      end;
      SelText := jreFormula.GetTextRange(NewSelection.cpMin, NewSelection.cpMax);
      if SelText = '(' then
      begin
        MatchStartingParen(PriorSelection);
      end
      else if SelText = ')' then
      begin
        MatchEndingParen(PriorSelection);
      end;
    finally
      jreFormula.SetSelection(PriorSelection.cpMin, PriorSelection.cpMax, False);
    end;
  finally
    FUpdating := False;
  end;
end;

procedure TfrmEquationEditor.MatchStartingParen(PriorSelection: TCharRange);
var
  Index: Integer;
  Level: Integer;
  StoredLevel: Integer;
  SelText: string;
  NewSelection: TCharRange;
  InString: boolean;
begin
  NewSelection.cpMin := 0;
  NewSelection.cpMax := 1;
  StoredLevel := -1;
  Level := 0;
  InString := False;
  for Index := 0 to MAXINT do
  begin
    SelText := jreFormula.GetTextRange(NewSelection.cpMin, NewSelection.cpMax);
    jreFormula.SetSelection(NewSelection.cpMin, NewSelection.cpMax, False);
    if SelText = '' then
    begin
      break;
    end
    else if (SelText = '"') and not InString then
    begin
      InString := True;
    end
    else if SelText = '"' then
    begin
      InString := False;
    end
    else if InString then
    begin
      if NewSelection.cpMin = PriorSelection.cpMin then
      begin
        break;
      end;
    end
    else if SelText = '(' then
    begin
      Inc(Level);
      if NewSelection.cpMin = PriorSelection.cpMin then
      begin
        jreFormula.SetSelection(NewSelection.cpMin, NewSelection.cpMax, False);
        jreFormula.SelAttributes.BackColor := clAqua;
        FSetColor := True;
        StoredLevel := Level;
      end;
    end
    else if SelText = ')' then
    begin
      if Level = StoredLevel then
      begin
        jreFormula.SetSelection(NewSelection.cpMin, NewSelection.cpMax, False);
        jreFormula.SelAttributes.BackColor := clAqua;
        break;
      end;
      Dec(Level);
    end;
    Inc(NewSelection.cpMin);
    Inc(NewSelection.cpMax);
  end;
end;

procedure TfrmEquationEditor.MatchEndingParen(PriorSelection: TCharRange);
var
  Levels: TIntegerList;
  Starts: TIntegerList;
  StoredLevel: Integer;
  Level: Integer;
  Index: Integer;
  NewSelection: TCharRange;
  SelText: string;
  InString: boolean;
begin
  Levels := TIntegerList.Create;
  Starts := TIntegerList.Create;
  try
    NewSelection.cpMin := 0;
    NewSelection.cpMax := 1;
    StoredLevel := -1;
    Level := 0;
    InString := False;
    for Index := 0 to MAXINT do
    begin
      SelText := jreFormula.GetTextRange(NewSelection.cpMin, NewSelection.cpMax);
//      SelText := jreFormula.SelText;
      if SelText = '' then
      begin
        break;
      end
      else if (SelText = '"') and not InString then
      begin
        InString := True;
      end
      else if SelText = '"' then
      begin
        InString := False;
      end
      else if InString then
      begin
        if NewSelection.cpMin = PriorSelection.cpMin then
        begin
          break;
        end;
      end
      else if SelText = '(' then
      begin
        Inc(Level);
        Levels.Add(Level);
        Starts.Add(NewSelection.cpMin);
      end
      else if SelText = ')' then
      begin
        if NewSelection.cpMin = PriorSelection.cpMin then
        begin
          jreFormula.SetSelection(NewSelection.cpMin, NewSelection.cpMax, False);
          jreFormula.SelAttributes.BackColor := clAqua;
          StoredLevel := Level;
          FSetColor := True;
          break;
        end;
        Dec(Level);
      end;
      Inc(NewSelection.cpMin);
      Inc(NewSelection.cpMax);
    end;
    if StoredLevel >= 0 then
    begin
      for Index := Levels.Count - 1 downto 0 do
      begin
        if Levels[Index] = StoredLevel then
        begin
          jreFormula.SetSelection(Starts[Index], Starts[Index] + 1, False);
          jreFormula.SelAttributes.BackColor := clAqua;
          break;
        end;
      end;
    end;
  finally
    Levels.Free;
    Starts.Free;
  end;
end;


end.
