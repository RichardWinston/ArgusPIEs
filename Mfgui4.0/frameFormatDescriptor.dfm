object frameFormat: TframeFormat
  Left = 0
  Top = 0
  Width = 174
  Height = 23
  TabOrder = 0
  object Label1: TLabel
    Left = 107
    Top = 5
    Width = 5
    Height = 16
    Caption = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblResult: TLabel
    Left = 132
    Top = 5
    Width = 3
    Height = 16
  end
  object comboP: TComboBox
    Left = 0
    Top = 0
    Width = 41
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 0
    OnChange = comboPChange
    Items.Strings = (
      ''
      '1P')
  end
  object comboREdit: TComboBox
    Left = 40
    Top = 0
    Width = 41
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 1
    OnChange = comboPChange
    Items.Strings = (
      'F'
      'D'
      'E'
      'EN'
      'ES'
      'G')
  end
  object adeW: TArgusDataEntry
    Left = 80
    Top = 0
    Width = 25
    Height = 22
    ItemHeight = 16
    TabOrder = 2
    Text = '13'
    OnChange = comboPChange
    DataType = dtInteger
    Max = 1
    Min = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object adeD: TArgusDataEntry
    Left = 112
    Top = 0
    Width = 17
    Height = 22
    ItemHeight = 16
    TabOrder = 3
    Text = '5'
    OnChange = comboPChange
    OnExit = adeDExit
    DataType = dtInteger
    Max = 1
    Min = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
end
