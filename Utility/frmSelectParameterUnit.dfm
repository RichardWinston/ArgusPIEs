object frmSelectParameter: TfrmSelectParameter
  Left = 192
  Top = 119
  HelpContext = 210
  Caption = 'Select Parameter'
  ClientHeight = 73
  ClientWidth = 253
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
  object sicomboParameters: TsiComboBox
    Left = 8
    Top = 8
    Width = 233
    Height = 27
    Style = csDropDownList
    ItemHeight = 19
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 88
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 168
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn3: TBitBtn
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkHelp
  end
end
