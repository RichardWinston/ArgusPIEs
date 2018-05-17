object frmConvertChoices: TfrmConvertChoices
  Left = 500
  Top = 286
  HelpContext = 239
  Caption = 'Convert'
  ClientHeight = 167
  ClientWidth = 330
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
    Left = 9
    Top = 8
    Width = 313
    Height = 121
    Caption = 'Convert'
    Items.Strings = (
      'Contours to Data...'
      'Data to Contours...'
      'Reverse Contours on Clipboard...'
      'Mesh Objects to Contours...'
      'Mesh to Contours...')
    TabOrder = 0
    OnClick = rgChoiceClick
  end
  object btnCancel: TBitBtn
    Left = 168
    Top = 136
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object btnOK: TBitBtn
    Left = 248
    Top = 136
    Width = 75
    Height = 25
    Enabled = False
    TabOrder = 4
    Kind = bkOK
  end
  object BitBtn1: TBitBtn
    Left = 88
    Top = 136
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkHelp
  end
  object btnAbout: TButton
    Left = 8
    Top = 136
    Width = 73
    Height = 25
    Caption = 'About'
    TabOrder = 1
    OnClick = btnAboutClick
  end
end
