object frmTimeConverter: TfrmTimeConverter
  Left = 320
  Top = 135
  Width = 352
  Height = 280
  Caption = 'Time Converter'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 56
    Height = 19
    Caption = 'Convert'
  end
  object Label2: TLabel
    Left = 168
    Top = 11
    Width = 13
    Height = 19
    Caption = 'in'
  end
  object Label3: TLabel
    Left = 256
    Top = 11
    Width = 79
    Height = 19
    Caption = 'to seconds'
  end
  object Label4: TLabel
    Left = 8
    Top = 43
    Width = 64
    Height = 19
    Caption = 'Result = '
  end
  object lblSeconds: TLabel
    Left = 8
    Top = 72
    Width = 79
    Height = 19
    Caption = 'lblSeconds'
  end
  object lblMinutes: TLabel
    Left = 8
    Top = 96
    Width = 71
    Height = 19
    Caption = 'lblMinutes'
  end
  object lblHours: TLabel
    Left = 8
    Top = 120
    Width = 58
    Height = 19
    Caption = 'lblHours'
  end
  object lblDays: TLabel
    Left = 8
    Top = 144
    Width = 53
    Height = 19
    Caption = 'lblDays'
  end
  object lblMonths: TLabel
    Left = 8
    Top = 168
    Width = 67
    Height = 19
    Caption = 'lblMonths'
  end
  object lblYears: TLabel
    Left = 8
    Top = 192
    Width = 58
    Height = 19
    Caption = 'lblYears'
  end
  object adeInput: TArgusDataEntry
    Left = 72
    Top = 8
    Width = 89
    Height = 22
    ItemHeight = 19
    TabOrder = 0
    Text = '0'
    OnChange = adeInputChange
    DataType = dtReal
    Max = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object comboTimeUnits: TComboBox
    Left = 184
    Top = 7
    Width = 65
    Height = 27
    Style = csDropDownList
    ItemHeight = 19
    TabOrder = 1
    OnChange = adeInputChange
    Items.Strings = (
      's'
      'min'
      'hr'
      'days'
      'months'
      'years')
  end
  object adeOutput: TArgusDataEntry
    Left = 72
    Top = 40
    Width = 89
    Height = 22
    ItemHeight = 19
    TabOrder = 2
    Text = '0'
    OnChange = adeOutputChange
    DataType = dtReal
    Max = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 168
    Top = 216
    Width = 81
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 256
    Top = 216
    Width = 83
    Height = 25
    TabOrder = 4
    Kind = bkOK
  end
end
