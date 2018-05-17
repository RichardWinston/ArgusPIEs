object frmPointEdit: TfrmPointEdit
  Left = 447
  Top = 162
  Width = 195
  Height = 150
  Caption = 'Coordinates'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object lblX: TLabel
    Left = 8
    Top = 11
    Width = 11
    Height = 19
    Caption = 'X'
  end
  object lblY: TLabel
    Left = 8
    Top = 35
    Width = 11
    Height = 19
    Caption = 'Y'
  end
  object lblZ: TLabel
    Left = 8
    Top = 59
    Width = 9
    Height = 19
    Caption = 'Z'
  end
  object adeX: TArgusDataEntry
    Left = 24
    Top = 8
    Width = 153
    Height = 22
    ItemHeight = 19
    TabOrder = 0
    Text = '0'
    DataType = dtReal
    Max = 1
    ChangeDisabledColor = True
  end
  object adeY: TArgusDataEntry
    Left = 24
    Top = 32
    Width = 153
    Height = 22
    ItemHeight = 19
    TabOrder = 1
    Text = '0'
    DataType = dtReal
    Max = 1
    ChangeDisabledColor = True
  end
  object adeZ: TArgusDataEntry
    Left = 24
    Top = 56
    Width = 153
    Height = 22
    ItemHeight = 19
    TabOrder = 2
    Text = '0'
    DataType = dtReal
    Max = 1
    ChangeDisabledColor = True
  end
  object btCancel: TBitBtn
    Left = 8
    Top = 88
    Width = 81
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object btnOK: TBitBtn
    Left = 96
    Top = 88
    Width = 83
    Height = 25
    TabOrder = 4
    Kind = bkOK
  end
end
