object frmLayerName: TfrmLayerName
  Left = 213
  Top = 116
  HelpContext = 210
  Caption = 'Layer Name'
  ClientHeight = 241
  ClientWidth = 299
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
  PixelsPerInch = 120
  TextHeight = 19
  object rgLayerType: TRadioGroup
    Left = 8
    Top = 32
    Width = 281
    Height = 65
    Caption = 'Import data relative to existing'
    ItemIndex = 0
    Items.Strings = (
      'Grid'
      'Mesh')
    TabOrder = 1
    OnClick = rgLayerTypeClick
  end
  object comboLayerName: TComboBox
    Left = 8
    Top = 176
    Width = 281
    Height = 27
    Style = csDropDownList
    ItemHeight = 19
    TabOrder = 3
  end
  object BitBtn1: TBitBtn
    Left = 216
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 6
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 136
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object rgGridType: TRadioGroup
    Left = 7
    Top = 104
    Width = 281
    Height = 65
    Caption = 'Grid type'
    ItemIndex = 0
    Items.Strings = (
      'Block-Centered (e.g. MODFLOW)'
      'Grid-Centered (e.g. HST3D)')
    TabOrder = 2
    OnClick = rgLayerTypeClick
  end
  object cbImportDemOutline: TCheckBox
    Left = 8
    Top = 8
    Width = 241
    Height = 17
    Caption = 'Import only DEM Outline'
    TabOrder = 0
    OnClick = rgLayerTypeClick
  end
  object BitBtn3: TBitBtn
    Left = 56
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkHelp
  end
end
