object frmSetRowColumnConstantWidths: TfrmSetRowColumnConstantWidths
  Left = 213
  Top = 116
  Width = 315
  Height = 98
  Caption = 'frmSetRowColumnConstantWidths'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 16
  object lblRowOrColumn: TLabel
    Left = 160
    Top = 11
    Width = 127
    Height = 16
    Caption = 'Row or Column Width'
  end
  object adeRowOrColumn: TArgusDataEntry
    Left = 8
    Top = 8
    Width = 145
    Height = 22
    ItemHeight = 16
    TabOrder = 0
    Text = '0'
    DataType = dtReal
    Max = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 144
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 224
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
end
