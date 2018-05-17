inherited frmSamplePoints: TfrmSamplePoints
  Left = 395
  Top = 224
  HelpContext = 226
  Caption = 'Sample Data'
  ClientHeight = 114
  ClientWidth = 170
  Font.Height = -17
  OldCreateOrder = False
  Position = poScreenCenter
  ExplicitWidth = 188
  ExplicitHeight = 159
  PixelsPerInch = 120
  TextHeight = 19
  object StatusBar1: TStatusBar [0]
    Left = 0
    Top = 95
    Width = 170
    Height = 19
    Panels = <>
    ParentFont = True
    SimplePanel = True
    UseSystemFont = False
  end
  object btrRead: TBitBtn [1]
    Left = 8
    Top = 4
    Width = 153
    Height = 25
    Caption = 'Read File'
    TabOrder = 0
    OnClick = Open1Click
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
      07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
      0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
  end
  object btnAbout: TButton [2]
    Left = 8
    Top = 36
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 1
    OnClick = btnAboutClick
  end
  object BitBtn1: TBitBtn [3]
    Left = 86
    Top = 36
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkHelp
  end
  object btnCancel: TBitBtn [4]
    Left = 8
    Top = 68
    Width = 75
    Height = 25
    TabOrder = 3
    OnClick = btnCancelClick
    Kind = bkCancel
  end
  object btnOK: TBitBtn [5]
    Left = 86
    Top = 68
    Width = 75
    Height = 25
    TabOrder = 4
    OnClick = btnOKClick
    Kind = bkOK
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 32
    Top = 32
  end
end
