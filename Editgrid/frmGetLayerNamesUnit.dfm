object frmGetLayerNames: TfrmGetLayerNames
  Left = 213
  Top = 116
  Width = 265
  Height = 178
  Caption = 'Get Layer Names'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 156
    Height = 15
    Caption = 'Choose Domain Outline layer'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 118
    Height = 15
    Caption = 'Choose Density  layer'
  end
  object comboDomainOutline: TComboBox
    Left = 8
    Top = 32
    Width = 241
    Height = 23
    Style = csDropDownList
    ItemHeight = 15
    TabOrder = 0
  end
  object comboDensity: TComboBox
    Left = 8
    Top = 88
    Width = 241
    Height = 23
    Style = csDropDownList
    ItemHeight = 15
    TabOrder = 1
  end
  object btnOK: TBitBtn
    Left = 176
    Top = 120
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object btCancel: TBitBtn
    Left = 96
    Top = 120
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
end
