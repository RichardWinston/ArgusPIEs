object frmSetRowColumnConstantWidths: TfrmSetRowColumnConstantWidths
  Left = 213
  Top = 116
  HelpContext = 130
  Caption = 'Set Row or Column Widths'
  ClientHeight = 69
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 19
  object lblRowOrColumn: TLabel
    Left = 160
    Top = 11
    Width = 153
    Height = 19
    Caption = 'Row or Column Width'
  end
  object adeRowOrColumn: TArgusDataEntry
    Left = 8
    Top = 8
    Width = 145
    Height = 22
    ItemHeight = 19
    TabOrder = 0
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 160
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 240
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn3: TBitBtn
    Left = 80
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkHelp
  end
end
