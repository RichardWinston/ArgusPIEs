object frmGetLayerNames: TfrmGetLayerNames
  Left = 533
  Top = 249
  HelpContext = 130
  Caption = 'Get Layer Names'
  ClientHeight = 195
  ClientWidth = 260
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
    Top = 160
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkOK
  end
  object btCancel: TBitBtn
    Left = 96
    Top = 160
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object cbBlockCenteredGrid: TCheckBox95
    Left = 8
    Top = 120
    Width = 169
    Height = 33
    Alignment = taLeftJustify
    Caption = 'Block Centered Grid (for example, MODFLOW)'
    Checked = True
    State = cbChecked
    TabOrder = 2
    WordWrap = True
    AlignmentBtn = taLeftJustify
    LikePushButton = False
    VerticalAlignment = vaTop
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 160
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkHelp
  end
end
