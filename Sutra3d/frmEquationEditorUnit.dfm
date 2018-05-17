inherited frmEquationEditor: TfrmEquationEditor
  Left = 201
  Top = 175
  Width = 519
  Height = 427
  Caption = 'UCODE Expression Editor'
  Font.Charset = DEFAULT_CHARSET
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 289
    Top = 0
    Width = 5
    Height = 352
    Cursor = crHSplit
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 352
    Width = 511
    Height = 41
    Align = alBottom
    ParentColor = True
    TabOrder = 0
    object btnCancel: TBitBtn
      Left = 408
      Top = 5
      Width = 91
      Height = 33
      Anchors = [akTop, akRight]
      TabOrder = 2
      Kind = bkCancel
    end
    object btnOK: TBitBtn
      Left = 312
      Top = 5
      Width = 91
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = btnOKClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        04000000000068010000120B0000120B00001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object btnHelp: TBitBtn
      Left = 216
      Top = 5
      Width = 91
      Height = 33
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkHelp
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 289
    Height = 352
    Align = alLeft
    ParentColor = True
    TabOrder = 1
    object JvNetscapeSplitter1: TJvNetscapeSplitter
      Left = 1
      Top = 98
      Width = 287
      Height = 10
      Cursor = crVSplit
      Align = alTop
      MinSize = 1
      Maximized = False
      Minimized = False
      ButtonCursor = crDefault
    end
    object pnlButtons: TPanel
      Left = 1
      Top = 205
      Width = 287
      Height = 146
      Align = alBottom
      ParentColor = True
      TabOrder = 0
      object gbNumbers: TGroupBox
        Left = 95
        Top = 6
        Width = 106
        Height = 131
        Caption = 'Numbers'
        TabOrder = 0
        object btn7: TButton
          Left = 8
          Top = 20
          Width = 25
          Height = 25
          Caption = '7'
          TabOrder = 0
          OnClick = buttonClick
        end
        object btn8: TButton
          Left = 39
          Top = 20
          Width = 25
          Height = 25
          Caption = '8'
          TabOrder = 1
          OnClick = buttonClick
        end
        object btn9: TButton
          Left = 70
          Top = 20
          Width = 25
          Height = 25
          Caption = '9'
          TabOrder = 2
          OnClick = buttonClick
        end
        object btn6: TButton
          Left = 70
          Top = 47
          Width = 25
          Height = 25
          Caption = '6'
          TabOrder = 3
          OnClick = buttonClick
        end
        object btn5: TButton
          Left = 39
          Top = 47
          Width = 25
          Height = 25
          Caption = '5'
          TabOrder = 7
          OnClick = buttonClick
        end
        object btn4: TButton
          Left = 8
          Top = 47
          Width = 25
          Height = 25
          Caption = '4'
          TabOrder = 10
          OnClick = buttonClick
        end
        object btn1: TButton
          Left = 8
          Top = 74
          Width = 25
          Height = 25
          Caption = '1'
          TabOrder = 5
          OnClick = buttonClick
        end
        object btn2: TButton
          Left = 39
          Top = 74
          Width = 25
          Height = 25
          Caption = '2'
          TabOrder = 6
          OnClick = buttonClick
        end
        object btn3: TButton
          Left = 70
          Top = 74
          Width = 25
          Height = 25
          Caption = '3'
          TabOrder = 8
          OnClick = buttonClick
        end
        object btn0: TButton
          Left = 8
          Top = 101
          Width = 25
          Height = 25
          Caption = '0'
          TabOrder = 4
          OnClick = buttonClick
        end
        object btnE: TButton
          Left = 39
          Top = 101
          Width = 25
          Height = 25
          Caption = 'E'
          TabOrder = 9
          OnClick = buttonClick
        end
        object btnDecimal: TButton
          Left = 70
          Top = 101
          Width = 25
          Height = 25
          Caption = '.'
          TabOrder = 11
          OnClick = buttonClick
        end
      end
      object gbOperators: TGroupBox
        Left = 209
        Top = 6
        Width = 72
        Height = 131
        Caption = 'Operators'
        TabOrder = 1
        object btnOpenParen: TButton
          Left = 8
          Top = 20
          Width = 25
          Height = 25
          Caption = '('
          TabOrder = 0
          OnClick = buttonClick
        end
        object btnCloseParen: TButton
          Left = 39
          Top = 20
          Width = 25
          Height = 25
          Caption = ')'
          TabOrder = 1
          OnClick = buttonClick
        end
        object btnDivide: TButton
          Left = 39
          Top = 47
          Width = 25
          Height = 25
          Hint = 'division operator'
          Caption = '/'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = buttonClick
        end
        object btnMultiply: TButton
          Left = 8
          Top = 47
          Width = 25
          Height = 25
          Hint = 'multiplication operator'
          Caption = '*'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = buttonClick
        end
        object btnPlus: TButton
          Left = 8
          Top = 74
          Width = 25
          Height = 25
          Hint = 'plus operator'
          Caption = '+'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = buttonClick
        end
        object btnMinus: TButton
          Left = 39
          Top = 74
          Width = 25
          Height = 25
          Hint = 'minus operator'
          Caption = '-'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = buttonClick
        end
        object btnPower: TButton
          Left = 39
          Top = 101
          Width = 25
          Height = 25
          Caption = '^'
          TabOrder = 4
          OnClick = buttonClick
        end
        object btnDoubleAsterisk: TButton
          Left = 8
          Top = 101
          Width = 25
          Height = 25
          Caption = '**'
          TabOrder = 5
          OnClick = buttonClick
        end
      end
    end
    object tvFormulaDiagram: TTreeView
      Left = 1
      Top = 1
      Width = 287
      Height = 97
      Align = alTop
      Indent = 19
      TabOrder = 1
      OnCollapsed = tvFormulaDiagramCollapsed
      OnExpanded = tvFormulaDiagramExpanded
    end
    object jreFormula: TJvRichEdit
      Left = 1
      Top = 108
      Width = 287
      Height = 97
      Align = alClient
      AutoSize = False
      HideSelection = False
      ScrollBars = ssVertical
      TabOrder = 2
      OnChange = jreFormulaChange
      OnDblClick = jreFormulaDblClick
      OnMouseUp = jreFormulaMouseUp
      OnSelectionChange = jreFormulaSelectionChange
    end
  end
  object pnlRight: TPanel
    Left = 294
    Top = 0
    Width = 217
    Height = 352
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object pnlLabelItemTree: TPanel
      Left = 0
      Top = 0
      Width = 217
      Height = 41
      Align = alTop
      Caption = 'Double-click to insert into formula'
      ParentColor = True
      TabOrder = 0
    end
    object tvItems: TTreeView
      Left = 0
      Top = 41
      Width = 217
      Height = 311
      Hint = 'Double-click to insert selected item into formula'
      Align = alClient
      Indent = 19
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      OnChange = tvItemsChange
      OnDblClick = tvItemsDblClick
    end
  end
  object rbFormulaParser: TRbwParser
    Left = 40
    Top = 8
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerSetSelection
    Left = 8
    Top = 8
  end
end
