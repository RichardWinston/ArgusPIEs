object frameGWM: TframeGWM
  Left = 0
  Top = 0
  Width = 443
  Height = 270
  Align = alClient
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlBottom: TPanel
    Left = 0
    Top = 221
    Width = 443
    Height = 49
    Align = alBottom
    TabOrder = 0
    object lblDecisionVariableCount: TLabel
      Left = 88
      Top = 8
      Width = 109
      Height = 30
      Caption = 'Number of Decision Variables '
      WordWrap = True
    end
    object adeDecisionVariableCount: TArgusDataEntry
      Left = 8
      Top = 12
      Width = 73
      Height = 22
      ItemHeight = 15
      TabOrder = 0
      Text = '0'
      OnExit = adeDecisionVariableCountExit
      DataType = dtInteger
      Max = 1
      CheckMin = True
      ChangeDisabledColor = True
    end
    object btnAdd: TButton
      Left = 216
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnInsert: TButton
      Left = 296
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Insert'
      TabOrder = 2
      OnClick = btnInsertClick
    end
    object btnDelete: TButton
      Left = 376
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 3
      OnClick = btnDeleteClick
    end
  end
  object dgVariables: TRbwDataGrid2
    Left = 0
    Top = 0
    Width = 443
    Height = 221
    Align = alClient
    ColCount = 3
    Enabled = False
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
        Format = rcf2String
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
        Format = rcf2String
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
        Format = rcf2String
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
    WordWrapColTitles = False
    UnselectableColor = clBtnFace
    ColWidths = (
      64
      64
      38)
  end
end
