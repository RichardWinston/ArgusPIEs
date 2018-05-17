object frmMeshLayerChoice: TfrmMeshLayerChoice
  Left = 449
  Top = 257
  HelpContext = 220
  Caption = 'frmMeshLayerChoice'
  ClientHeight = 193
  ClientWidth = 252
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 85
    Height = 19
    Caption = 'From Layer:'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 65
    Height = 19
    Caption = 'To Layer:'
  end
  object siComboFrom: TsiComboBox
    Left = 8
    Top = 32
    Width = 233
    Height = 27
    Style = csDropDownList
    ItemHeight = 19
    TabOrder = 0
  end
  object siComboTo: TsiComboBox
    Left = 8
    Top = 88
    Width = 233
    Height = 27
    Style = csDropDownList
    ItemHeight = 19
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 88
    Top = 160
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object btnOK: TBitBtn
    Left = 168
    Top = 160
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkOK
  end
  object BitBtn1: TBitBtn
    Left = 88
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkHelp
  end
  object btnAbout: TButton
    Left = 168
    Top = 128
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 3
    OnClick = btnAboutClick
  end
end
