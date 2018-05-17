object frmJpegChoices: TfrmJpegChoices
  Left = 213
  Top = 116
  BorderStyle = bsDialog
  Caption = 'Jpeg Image Options'
  ClientHeight = 95
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 72
    Top = 16
    Width = 122
    Height = 17
    Caption = 'Compression Quality'
  end
  object seQuality: TSpinEdit
    Left = 8
    Top = 8
    Width = 57
    Height = 27
    MaxValue = 100
    MinValue = 1
    TabOrder = 0
    Value = 1
  end
  object cbProgressive: TCheckBox
    Left = 8
    Top = 40
    Width = 169
    Height = 17
    Caption = 'Progressive Encoding'
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 120
    Top = 64
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 40
    Top = 64
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 'JPEG files (*.jpg,*.jpeg)|*.jpg;*.jpeg|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 136
    Top = 8
  end
end
