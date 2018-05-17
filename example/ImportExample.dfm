object frmImportExample: TfrmImportExample
  Left = 306
  Top = 107
  Width = 497
  Height = 374
  Caption = 'Paste contours here'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 306
    Width = 489
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 88
      Height = 13
      Caption = 'Use Ctrl-V to paste'
    end
    object btnOK: TBitBtn
      Left = 328
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object btnCancel: TBitBtn
      Left = 408
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 489
    Height = 306
    Align = alClient
    TabOrder = 1
  end
end
