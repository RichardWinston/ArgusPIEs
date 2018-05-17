object frmDecayConstCalculator: TfrmDecayConstCalculator
  Left = 655
  Top = 256
  Width = 468
  Height = 302
  Caption = 'Calculate first order production term from half life'
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
  PixelsPerInch = 120
  TextHeight = 19
  object Label76: TLabel
    Left = 216
    Top = 42
    Width = 241
    Height = 19
    Caption = 'First-order production term [s^-1]'
  end
  object Label72: TLabel
    Left = 216
    Top = 10
    Width = 73
    Height = 19
    Caption = 'Half-life in'
  end
  object lblSec: TLabel
    Left = 8
    Top = 72
    Width = 44
    Height = 19
    Caption = 'lblSec'
  end
  object lblMin: TLabel
    Left = 8
    Top = 96
    Width = 41
    Height = 19
    Caption = 'lblMin'
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
  object lblWeeks: TLabel
    Left = 8
    Top = 168
    Width = 66
    Height = 19
    Caption = 'lblWeeks'
  end
  object lblMonths: TLabel
    Left = 8
    Top = 192
    Width = 67
    Height = 19
    Caption = 'lblMonths'
  end
  object lblYears: TLabel
    Left = 8
    Top = 216
    Width = 58
    Height = 19
    Caption = 'lblYears'
  end
  object adeHalfLife: TArgusDataEntry
    Left = 8
    Top = 8
    Width = 201
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
  object adeProductionTerm: TArgusDataEntry
    Left = 8
    Top = 40
    Width = 201
    Height = 22
    ItemHeight = 19
    TabOrder = 1
    Text = '0.693147180559945'
    DataType = dtReal
    Max = 1
    ChangeDisabledColor = True
  end
  object comboHalfLifeTimeUnits: TComboBox
    Left = 300
    Top = 6
    Width = 109
    Height = 27
    Style = csDropDownList
    ItemHeight = 19
    TabOrder = 2
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
  object BitBtn1: TBitBtn
    Left = 376
    Top = 240
    Width = 83
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 288
    Top = 240
    Width = 81
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
end
