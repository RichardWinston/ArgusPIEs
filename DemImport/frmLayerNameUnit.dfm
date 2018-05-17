object frmLayerName: TfrmLayerName
  Left = 213
  Top = 116
  Width = 312
  Height = 250
  Caption = 'Layer Name'
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
  object rgLayerType: TRadioGroup
    Left = 16
    Top = 16
    Width = 281
    Height = 65
    Caption = 'Import data relative to existing'
    ItemIndex = 0
    Items.Strings = (
      'Grid'
      'Mesh')
    TabOrder = 0
    OnClick = rgLayerTypeClick
  end
  object comboLayerName: TComboBox
    Left = 16
    Top = 160
    Width = 281
    Height = 25
    Style = csDropDownList
    ItemHeight = 17
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 224
    Top = 192
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 144
    Top = 192
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object rgGridType: TRadioGroup
    Left = 15
    Top = 88
    Width = 281
    Height = 65
    Caption = 'Grid type'
    ItemIndex = 0
    Items.Strings = (
      'Block-Centered (e.g. MODFLOW)'
      'Grid-Centered (e.g. HST3D)')
    TabOrder = 4
    OnClick = rgLayerTypeClick
  end
end
