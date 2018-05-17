object frmMultValue: TfrmMultValue
  Left = 526
  Top = 329
  Width = 204
  Height = 140
  Caption = 'Constant Value'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 35
    Height = 19
    Caption = 'Value'
  end
  object adeValue: TArgusDataEntry
    Left = 16
    Top = 32
    Width = 161
    Height = 22
    ItemHeight = 19
    TabOrder = 0
    Text = '0'
    DataType = dtReal
    Max = 1
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 104
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
end
