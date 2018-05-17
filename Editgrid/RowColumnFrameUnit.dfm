object FramePosition: TFramePosition
  Left = 0
  Top = 0
  Width = 190
  Height = 339
  TabOrder = 0
  object dgPositions: TDataGrid
    Left = 0
    Top = 49
    Width = 190
    Height = 290
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
    Width = 190
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblCount: TLabel
      Left = 2
      Top = 0
      Width = 165
      Height = 16
      Caption = 'Number of column positions'
    end
    object seCount: TSpinEdit
      Left = 2
      Top = 16
      Width = 65
      Height = 26
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 1
      OnChange = seCountChange
    end
  end
end
