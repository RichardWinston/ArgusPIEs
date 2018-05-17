object Form1: TForm1
  Left = 197
  Top = 127
  Width = 578
  Height = 328
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 570
    Height = 260
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 260
    Width = 570
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 273
      Height = 25
      Caption = 'Read MODFLOW input'
      TabOrder = 0
      OnClick = Button1Click
    end
    object BitBtn1: TBitBtn
      Left = 287
      Top = 8
      Width = 76
      Height = 25
      TabOrder = 1
      Kind = bkClose
    end
  end
end
