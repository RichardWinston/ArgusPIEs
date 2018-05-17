object FrmDefaultValue: TFrmDefaultValue
  Left = 0
  Top = 0
  Width = 503
  Height = 27
  TabOrder = 0
  object lblParameterName: TLabel
    Left = 168
    Top = 5
    Width = 79
    Height = 13
    Caption = 'Parameter Name'
  end
  object btnSetValue: TButton
    Left = 8
    Top = 2
    Width = 73
    Height = 22
    Caption = 'Set Now'
    Enabled = False
    TabOrder = 0
    OnClick = btnSetValueClick
  end
  object adeProperty: TArgusDataEntry
    Left = 88
    Top = 2
    Width = 73
    Height = 22
    ItemHeight = 13
    TabOrder = 1
    Text = '0'
    OnChange = adePropertyChange
    Max = 1
    ChangeDisabledColor = True
  end
  object LayerClassName: TStringStorage
    Left = 424
  end
  object ParameterClassName: TStringStorage
    Left = 456
  end
end
