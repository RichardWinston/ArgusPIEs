object frmImportChoices: TfrmImportChoices
  Left = 417
  Top = 204
  HelpContext = 170
  Caption = 'Import'
  ClientHeight = 301
  ClientWidth = 391
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
  object btnOK: TBitBtn
    Left = 309
    Top = 272
    Width = 75
    Height = 25
    Enabled = False
    TabOrder = 4
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 229
    Top = 272
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object rgChoice: TRadioGroup
    Left = 8
    Top = 8
    Width = 377
    Height = 257
    Caption = 'Import'
    Items.Strings = (
      'Import Gridded Data...'
      'Import Points from Spreadsheet...'
      'Import Contours from Spreadsheet...'
      'Sample DEM Data...'
      'Copy Tri Mesh...'
      'Copy Quad Mesh...'
      'Paste Contours on Clipboard to Multiple Layers...'
      'Import Data...'
      'Sample Data...'
      'Import Shapefile...'
      'Import ASCII Raster Data')
    TabOrder = 0
    OnClick = rgChoiceClick
  end
  object BitBtn1: TBitBtn
    Left = 149
    Top = 272
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkHelp
  end
  object btnAbout: TButton
    Left = 69
    Top = 272
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 1
    OnClick = btnAboutClick
  end
end
