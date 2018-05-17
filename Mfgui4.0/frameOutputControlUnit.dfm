object frameOutputControl: TframeOutputControl
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  TabStop = True
  object pnlBottom: TPanel
    Left = 0
    Top = 199
    Width = 320
    Height = 41
    Align = alBottom
    TabOrder = 0
    object lblNumberOfRows: TLabel
      Left = 88
      Top = 13
      Width = 76
      Height = 13
      Caption = 'Number of rows'
    end
    object adeOutControlCount: TArgusDataEntry
      Left = 8
      Top = 8
      Width = 73
      Height = 22
      Hint = 'Change the number of rows'
      ItemHeight = 0
      TabOrder = 0
      Text = '1'
      OnExit = adeOutControlCountExit
      DataType = dtInteger
      Max = 1.000000000000000000
      Min = 1.000000000000000000
      CheckMax = True
      CheckMin = True
      ChangeDisabledColor = True
    end
  end
  object rdgOutputControl: TRbwDataGrid2
    Left = 0
    Top = 0
    Width = 320
    Height = 199
    Align = alClient
    ColCount = 2
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 1
    AutoDistributeText = False
    ColorSelectedRow = True
    Columns = <
      item
        CheckMax = False
        CheckMin = False
        Format = rcf2Integer
        LimitToList = False
        MaxLength = 0
        UseButton = False
        ButtonCaption = '...'
        ButtonWidth = 20
        AutoAdjustColWidths = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustRowHeights = False
      end
      item
        CheckMax = False
        CheckMin = False
        Format = rcf2Integer
        LimitToList = False
        MaxLength = 0
        UseButton = False
        ButtonCaption = '...'
        ButtonWidth = 20
        AutoAdjustColWidths = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustRowHeights = False
      end>
    SelectedRowColor = clAqua
    UnselectableColor = clBtnFace
    ColWidths = (
      157
      158)
  end
end
