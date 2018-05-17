object FramePosition: TFramePosition
  Left = 0
  Top = 0
  Width = 203
  Height = 339
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object dgPositions: TDataGrid
    Left = 0
    Top = 97
    Width = 203
    Height = 242
    Align = alClient
    ColCount = 2
    DefaultRowHeight = 20
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowMoving, goEditing, goTabs]
    TabOrder = 0
    Columns = <
      item
      end
      item
        Format = cfNumber
      end>
    RowCountMin = 0
    SelectedIndex = 1
    Version = '2.0'
    ColWidths = (
      64
      108)
    RowHeights = (
      20)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 203
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblCount: TLabel
      Left = 75
      Top = 3
      Width = 118
      Height = 38
      Caption = 'Number of column positions'
      WordWrap = True
    end
    object Label1: TLabel
      Left = 72
      Top = 42
      Width = 70
      Height = 19
      Caption = 'Multiplier'
    end
    object seCount: TSpinEdit
      Left = 2
      Top = 8
      Width = 65
      Height = 29
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 1
      OnChange = seCountChange
    end
    object Button1: TButton
      Left = 32
      Top = 66
      Width = 113
      Height = 25
      Caption = 'Paste'
      TabOrder = 1
      OnClick = Button1Click
    end
    object adeMultiplier: TArgusDataEntry
      Left = 2
      Top = 40
      Width = 63
      Height = 22
      ItemHeight = 19
      TabOrder = 2
      Text = '1'
      DataType = dtReal
      Max = 1
      CheckMin = True
      ChangeDisabledColor = True
    end
  end
end
