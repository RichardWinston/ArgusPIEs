object frmGridType: TfrmGridType
  Left = 213
  Top = 116
  Width = 305
  Height = 137
  Caption = 'What type of grid is this?'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 17
  object rgGridType: TRadioGroup
    Left = 8
    Top = 8
    Width = 281
    Height = 65
    Caption = 'What type of grid is this?'
    ItemIndex = 0
    Items.Strings = (
      'A block-centered grid (as in MODFLOW)'
      'A grid-centered grid')
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 216
    Top = 80
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkClose
  end
end
