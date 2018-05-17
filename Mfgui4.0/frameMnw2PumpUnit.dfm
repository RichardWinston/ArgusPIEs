object frameMnw2Pump: TframeMnw2Pump
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  TabStop = True
  object Label1: TLabel
    Left = 8
    Top = 3
    Width = 55
    Height = 13
    Margins.Left = 8
    Caption = 'Pump name'
  end
  object Label5: TLabel
    Left = 8
    Top = 47
    Width = 171
    Height = 13
    Margins.Left = 8
    Caption = 'Lift at which discharge = 0 (LIFTq0)'
  end
  object Label6: TLabel
    Left = 8
    Top = 91
    Width = 183
    Height = 26
    Margins.Left = 8
    Caption = 'Maximum lift at which discharge is not restricted (LIFTqmax)'
    WordWrap = True
  end
  object Label7: TLabel
    Left = 8
    Top = 151
    Width = 173
    Height = 26
    Margins.Left = 8
    Caption = 'Minimum change in computed water level (HWtol)'
    WordWrap = True
  end
  object Label8: TLabel
    Left = 295
    Top = 183
    Width = 122
    Height = 13
    Caption = 'Rows in table (PUMPCAP)'
  end
  object edPumpName: TEdit
    Left = 8
    Top = 20
    Width = 121
    Height = 21
    HelpContext = 4160
    Margins.Left = 8
    TabOrder = 0
    Text = 'Pump1'
    OnChange = edPumpNameChange
  end
  object adeLiftQ0: TArgusDataEntry
    Left = 8
    Top = 63
    Width = 87
    Height = 22
    HelpContext = 4165
    Margins.Left = 8
    ItemHeight = 13
    TabOrder = 1
    Text = '300'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object adeLiftQMax: TArgusDataEntry
    Left = 8
    Top = 123
    Width = 87
    Height = 22
    HelpContext = 4170
    Margins.Left = 8
    ItemHeight = 13
    TabOrder = 2
    Text = '5'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object adeHWtol: TArgusDataEntry
    Left = 8
    Top = 180
    Width = 87
    Height = 22
    HelpContext = 4175
    Margins.Left = 8
    ItemHeight = 13
    TabOrder = 3
    Text = '0.1'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object sePumpCap: TSpinEdit
    Left = 233
    Top = 180
    Width = 55
    Height = 22
    HelpContext = 4180
    MaxValue = 1000000
    MinValue = 1
    TabOrder = 4
    Value = 1
    OnChange = sePumpCapChange
  end
  object rdgLiftQ_Table: TRbwDataGrid4
    Left = 233
    Top = 3
    Width = 184
    Height = 169
    HelpContext = 4185
    ColCount = 3
    FixedCols = 1
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
    TabOrder = 5
    AutoDistributeText = True
    AutoIncreaseColCount = False
    AutoIncreaseRowCount = True
    SelectedRowOrColumnColor = clAqua
    UnselectableColor = clBtnFace
    ColorRangeSelection = False
    ColorSelectedRow = True
    Columns = <
      item
        AutoAdjustRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -11
        ButtonFont.Name = 'Tahoma'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustColWidths = False
      end
      item
        AutoAdjustRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -11
        ButtonFont.Name = 'Tahoma'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = True
        ComboUsed = False
        Format = rcf4Real
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustColWidths = False
      end
      item
        AutoAdjustRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -11
        ButtonFont.Name = 'Tahoma'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = True
        ComboUsed = False
        Format = rcf4Real
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustColWidths = False
      end>
    OnEndUpdate = rdgLiftQ_TableEndUpdate
    ColWidths = (
      30
      64
      64)
  end
end
