object frmDataLayerName: TfrmDataLayerName
  Left = 284
  Top = 116
  HelpContext = 240
  Caption = 'Data Layer Name'
  ClientHeight = 168
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 19
  object lblLayerName: TLabel
    Left = 8
    Top = 8
    Width = 307
    Height = 19
    Caption = 'Data Layer Name (new or existing data layer)'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 224
    Height = 95
    Caption = 
      'Note: When converting contours to data points, expressions that ' +
      'might cause a parameter to vary along the length of a contour ar' +
      'e ignored.'
    WordWrap = True
  end
  object BitBtn1: TBitBtn
    Left = 240
    Top = 112
    Width = 75
    Height = 24
    TabOrder = 3
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 240
    Top = 136
    Width = 75
    Height = 24
    TabOrder = 4
    OnClick = BitBtn2Click
    Kind = bkOK
  end
  object comboDataLayer: TComboBox
    Left = 8
    Top = 32
    Width = 305
    Height = 27
    ItemHeight = 19
    TabOrder = 0
    Text = 'New Data Layer'
    OnChange = comboDataLayerChange
  end
  object BitBtn3: TBitBtn
    Left = 240
    Top = 88
    Width = 75
    Height = 24
    TabOrder = 2
    Kind = bkHelp
  end
  object btnAbout: TButton
    Left = 240
    Top = 63
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 1
    OnClick = btnAboutClick
  end
end
