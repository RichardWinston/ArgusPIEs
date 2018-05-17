object frmCentralMeridian: TfrmCentralMeridian
  Left = 213
  Top = 116
  Width = 348
  Height = 230
  Caption = 'Central Meridian'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object rgCentralMeridians: TRadioGroup
    Left = 0
    Top = 0
    Width = 340
    Height = 120
    Align = alClient
    Caption = 'Central Meridians'
    TabOrder = 0
    OnClick = rgCentralMeridiansClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 120
    Width = 340
    Height = 83
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 186
      Height = 64
      Caption = 
        'More than one central meridian apply to the DEM'#39's you have selec' +
        'ted.  Which one do you want to use?'
      WordWrap = True
    end
    object BitBtn1: TBitBtn
      Left = 256
      Top = 48
      Width = 75
      Height = 25
      Enabled = False
      TabOrder = 0
      Kind = bkOK
    end
  end
end
