object frmCentralMeridian: TfrmCentralMeridian
  Left = 213
  Top = 116
  HelpContext = 210
  Caption = 'Central Meridian'
  ClientHeight = 219
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  HelpFile = 'Utility.hlp'
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 19
  object rgCentralMeridians: TRadioGroup
    Left = 0
    Top = 0
    Width = 374
    Height = 146
    Align = alClient
    Caption = 'Central Meridians'
    TabOrder = 0
    OnClick = rgCentralMeridiansClick
    ExplicitWidth = 357
  end
  object Panel1: TPanel
    Left = 0
    Top = 146
    Width = 374
    Height = 73
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 357
    object Label1: TLabel
      Left = 7
      Top = 8
      Width = 272
      Height = 57
      Caption = 
        'More than one central meridian apply to the DEM'#39's you have selec' +
        'ted.  Which one do you want to use?'
      WordWrap = True
    end
    object BitBtn1: TBitBtn
      Left = 288
      Top = 39
      Width = 75
      Height = 25
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Kind = bkHelp
    end
  end
end
