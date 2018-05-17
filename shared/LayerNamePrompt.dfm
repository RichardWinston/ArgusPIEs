object frmLayerNamePrompt: TfrmLayerNamePrompt
  Left = 466
  Top = 292
  Caption = 'Layer Already Exists'
  ClientHeight = 206
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 19
  object lblAlreadyExists: TLabel
    Left = 16
    Top = 32
    Width = 291
    Height = 19
    Caption = 'already exists. What do you want to do?'
  end
  object lblLayerName: TLabel
    Left = 16
    Top = 8
    Width = 99
    Height = 19
    Caption = 'lblLayerName'
  end
  object lblNewName: TLabel
    Left = 16
    Top = 120
    Width = 125
    Height = 19
    Caption = 'New Layer Name'
  end
  object rgAnswer: TRadioGroup
    Left = 16
    Top = 48
    Width = 337
    Height = 65
    ItemIndex = 1
    Items.Strings = (
      'Overwrite the existing data.'
      'Create a new layer with a different name.')
    TabOrder = 0
    OnClick = rgAnswerClick
  end
  object EdNewName: TEdit
    Left = 16
    Top = 144
    Width = 337
    Height = 27
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 272
    Top = 176
    Width = 83
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 184
    Top = 176
    Width = 81
    Height = 25
    TabOrder = 2
    Visible = False
    Kind = bkCancel
  end
end
