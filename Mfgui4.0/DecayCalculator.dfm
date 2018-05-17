object frmDecayCalculator: TfrmDecayCalculator
  Left = 192
  Top = 116
  Width = 381
  Height = 127
  HelpContext = 2330
  Caption = 'Calculate first-order decay rate from half-life'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 19
  object lblHalfLine: TLabel
    Left = 184
    Top = 10
    Width = 77
    Height = 19
    Caption = 'Half-life in'
  end
  object lblProductionTerm: TLabel
    Left = 184
    Top = 42
    Width = 183
    Height = 19
    Caption = 'First order decay rate (1/s)'
  end
  object adeHalfLife: TArgusDataEntry
    Left = 8
    Top = 8
    Width = 169
    Height = 22
    ItemHeight = 19
    TabOrder = 0
    Text = '1'
    OnChange = adeHalfLifeChange
    DataType = dtReal
    Max = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object comboHalfLifeTimeUnits: TComboBox
    Left = 276
    Top = 6
    Width = 77
    Height = 27
    Style = csDropDownList
    ItemHeight = 19
    TabOrder = 1
    OnChange = adeHalfLifeChange
    Items.Strings = (
      'seconds'
      'minutes'
      'hours'
      'days'
      'weeks'
      'months'
      'years')
  end
  object adeProductionTerm: TArgusDataEntry
    Left = 8
    Top = 40
    Width = 169
    Height = 22
    Color = clBtnFace
    Enabled = False
    ItemHeight = 19
    TabOrder = 2
    Text = '0.693147180559945'
    DataType = dtReal
    Max = 1
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 288
    Top = 64
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 208
    Top = 64
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object BitBtn3: TBitBtn
    Left = 128
    Top = 64
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkHelp
  end
end
