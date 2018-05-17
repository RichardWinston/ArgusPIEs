object FrmDefaultValue: TFrmDefaultValue
  Left = 0
  Top = 0
  Width = 437
  Height = 31
  TabOrder = 0
  object lblPermAngleXY: TLabel
    Left = 168
    Top = 8
    Width = 265
    Height = 16
    Caption = 'Hydraulic Conductivity Angle'
  end
  object Button1: TButton
    Left = 8
    Top = 5
    Width = 73
    Height = 22
    Caption = 'Set Now'
    TabOrder = 0
  end
  object adePermAngleXY: TArgusDataEntry
    Left = 88
    Top = 5
    Width = 73
    Height = 22
    ItemHeight = 16
    TabOrder = 1
    Text = '0'
    DataType = dtReal
    Max = 1
    ChangeDisabledColor = True
  end
end
