object frmLayerSelect: TfrmLayerSelect
  Left = 192
  Top = 107
  Width = 450
  Height = 401
  Caption = 'Select Layer'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 333
    Width = 442
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 352
      Top = 8
      Width = 83
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 264
      Top = 8
      Width = 81
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 442
    Height = 333
    Align = alClient
    TabOrder = 1
    object rgLayers: TRadioGroup
      Left = 0
      Top = 0
      Width = 436
      Height = 321
      Caption = 'Layers'
      TabOrder = 0
    end
  end
end
