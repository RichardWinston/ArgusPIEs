object frmEdit: TfrmEdit
  Left = 192
  Top = 119
  HelpContext = 90
  Caption = 'Edit'
  ClientHeight = 238
  ClientWidth = 329
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
  object rgChoice: TRadioGroup
    Left = 8
    Top = 8
    Width = 315
    Height = 193
    Caption = 'Edit'
    Items.Strings = (
      'Edit Contours...'
      'Declutter Contours...'
      'Join Contours...'
      'Edit Grid...'
      'Edit Data...'
      'Create Parameters in Multiple Layers...'
      'Set Multiple Parameters...'
      'Move Model...')
    TabOrder = 0
    OnClick = rgChoiceClick
  end
  object btnCancel: TBitBtn
    Left = 168
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object btnOK: TBitBtn
    Left = 248
    Top = 208
    Width = 75
    Height = 25
    Enabled = False
    TabOrder = 4
    Kind = bkOK
  end
  object BitBtn1: TBitBtn
    Left = 88
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkHelp
  end
  object btnAbout: TButton
    Left = 8
    Top = 208
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 1
    OnClick = btnAboutClick
  end
end
