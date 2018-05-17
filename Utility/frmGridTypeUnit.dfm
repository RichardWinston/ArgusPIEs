object frmGridType: TfrmGridType
  Left = 213
  Top = 116
  HelpContext = 130
  Caption = 'What type of grid is this?'
  ClientHeight = 116
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 19
  object rgGridType: TRadioGroup
    Left = 8
    Top = 8
    Width = 321
    Height = 65
    Caption = 'What type of grid is this?'
    ItemIndex = 0
    Items.Strings = (
      'A block-centered grid (as in MODFLOW)'
      'A grid-centered grid')
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 256
    Top = 80
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 176
    Top = 80
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkHelp
  end
end
