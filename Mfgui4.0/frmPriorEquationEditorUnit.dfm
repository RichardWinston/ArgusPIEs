object frmPriorEquationEditor: TfrmPriorEquationEditor
  Left = 744
  Top = 260
  HelpContext = 2270
  Caption = 'Prior Equation Editor'
  ClientHeight = 263
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object dgEquationParts: TDataGrid
    Left = 0
    Top = 0
    Width = 300
    Height = 182
    Align = alClient
    ColCount = 3
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
    TabOrder = 0
    Columns = <
      item
        LimitToList = True
        PickList.Strings = (
          '+'
          '-')
        Title.Caption = 'Sign'
        Title.WordWrap = False
      end
      item
        Format = cfNumber
        Title.Caption = 'Coefficient'
        Title.WordWrap = False
      end
      item
        LimitToList = True
        Title.Caption = 'Parameter Name'
        Title.WordWrap = False
      end>
    RowCountMin = 0
    OnUserChanged = dgEquationPartsUserChanged
    SelectedIndex = 0
    Version = '2.0'
    ExplicitHeight = 189
    ColWidths = (
      64
      90
      133)
  end
  object Panel1: TPanel
    Left = 0
    Top = 182
    Width = 300
    Height = 62
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 189
    object lblParamCount: TLabel
      Left = 64
      Top = 12
      Width = 76
      Height = 19
      Caption = 'Row Count'
    end
    object adeParamCount: TArgusDataEntry
      Left = 8
      Top = 8
      Width = 49
      Height = 22
      ItemHeight = 0
      TabOrder = 0
      Text = '1'
      OnExit = adeParamCountExit
      DataType = dtInteger
      Max = 1.000000000000000000
      CheckMin = True
      ChangeDisabledColor = True
    end
    object BitBtn1: TBitBtn
      Left = 128
      Top = 32
      Width = 67
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
    object BitBtn2: TBitBtn
      Left = 200
      Top = 32
      Width = 67
      Height = 25
      TabOrder = 2
      Kind = bkOK
    end
    object BitBtn3: TBitBtn
      Left = 56
      Top = 32
      Width = 67
      Height = 25
      TabOrder = 3
      Kind = bkHelp
    end
  end
  object sbEquation: TStatusBar
    Left = 0
    Top = 244
    Width = 300
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitTop = 251
  end
end
