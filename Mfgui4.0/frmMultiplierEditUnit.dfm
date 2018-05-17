object frmMultiplierEditor: TfrmMultiplierEditor
  Left = 612
  Top = 293
  Caption = 'Multiplier function editor'
  ClientHeight = 217
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object Splitter1: TSplitter
    Left = 0
    Top = 93
    Width = 334
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 95
  end
  object memoFunction: TMemo
    Left = 0
    Top = 0
    Width = 334
    Height = 93
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitHeight = 95
  end
  object Panel1: TPanel
    Left = 0
    Top = 185
    Width = 334
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 187
    DesignSize = (
      334
      32)
    object btnCancel: TBitBtn
      Left = 178
      Top = 5
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkCancel
    end
    object btnOK: TBitBtn
      Left = 258
      Top = 5
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      OnClick = btnOKClick
      Kind = bkOK
    end
    object BitBtn1: TBitBtn
      Left = 98
      Top = 5
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 2
      Kind = bkHelp
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 96
    Width = 334
    Height = 89
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 98
    object sgDefinedArrays: TStringGrid
      Left = 49
      Top = 0
      Width = 285
      Height = 89
      Align = alClient
      ColCount = 1
      DefaultColWidth = 277
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      TabOrder = 0
      OnDblClick = sgDefinedArraysDblClick
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 49
      Height = 89
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object btnPlus: TButton
        Left = 5
        Top = 5
        Width = 17
        Height = 17
        Caption = '+'
        TabOrder = 0
        OnClick = btnPlusClick
      end
      object btnMinus: TButton
        Left = 29
        Top = 5
        Width = 17
        Height = 17
        Caption = '-'
        TabOrder = 1
        OnClick = btnMinusClick
      end
      object btnMulitply: TButton
        Left = 5
        Top = 29
        Width = 17
        Height = 17
        Caption = '*'
        TabOrder = 2
        OnClick = btnMulitplyClick
      end
      object btnDivide: TButton
        Left = 29
        Top = 29
        Width = 17
        Height = 17
        Caption = '/'
        TabOrder = 3
        OnClick = btnDivideClick
      end
    end
  end
end
