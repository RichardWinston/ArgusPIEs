object frmDataLayerName: TfrmDataLayerName
  Left = 284
  Top = 116
  Width = 312
  Height = 167
  Caption = 'Data Layer Name'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 261
    Height = 16
    Caption = 'Data Layer Name (new or existing data layer)'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 208
    Height = 64
    Caption = 
      'Note: When converting contours to data points, expressions that ' +
      'might cause a parameter to vary along the length of a contour ar' +
      'e ignored.'
    WordWrap = True
  end
  object BitBtn1: TBitBtn
    Left = 224
    Top = 88
    Width = 75
    Height = 24
    TabOrder = 0
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 224
    Top = 112
    Width = 75
    Height = 24
    TabOrder = 1
    OnClick = BitBtn2Click
    Kind = bkOK
  end
  object comboDataLayer: TComboBox
    Left = 8
    Top = 32
    Width = 291
    Height = 24
    ItemHeight = 16
    TabOrder = 2
    Text = 'New Data Layer'
    OnChange = comboDataLayerChange
  end
  object BitBtn3: TBitBtn
    Left = 224
    Top = 64
    Width = 75
    Height = 24
    HelpContext = 10
    TabOrder = 3
    Kind = bkHelp
  end
end
