object frmRotation: TfrmRotation
  Left = 552
  Top = 202
  Caption = 'Calculate Rotated Coordinates'
  ClientHeight = 164
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 14
  object Label1: TLabel
    Left = 112
    Top = 8
    Width = 62
    Height = 14
    Caption = 'X Coordinate'
  end
  object Label2: TLabel
    Left = 201
    Top = 8
    Width = 63
    Height = 14
    Caption = 'Y Coordinate'
  end
  object Label4: TLabel
    Left = 8
    Top = 32
    Width = 88
    Height = 14
    Caption = 'HST3D Coordinate'
  end
  object Label5: TLabel
    Left = 8
    Top = 56
    Width = 91
    Height = 14
    Caption = 'Argus Coordinates'
  end
  object Label6: TLabel
    Left = 112
    Top = 80
    Width = 35
    Height = 14
    Caption = 'Column'
  end
  object Label7: TLabel
    Left = 198
    Top = 80
    Width = 23
    Height = 14
    Caption = 'Row'
  end
  object adeHST3DX: TArgusDataEntry
    Left = 112
    Top = 24
    Width = 80
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    ChangeDisabledColor = True
  end
  object adeHST3DY: TArgusDataEntry
    Left = 201
    Top = 24
    Width = 80
    Height = 22
    ItemHeight = 14
    TabOrder = 1
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    ChangeDisabledColor = True
  end
  object adeArgusX: TArgusDataEntry
    Left = 112
    Top = 48
    Width = 80
    Height = 22
    Color = clBtnFace
    Enabled = False
    ItemHeight = 14
    TabOrder = 2
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    ChangeDisabledColor = True
  end
  object adeArgusY: TArgusDataEntry
    Left = 201
    Top = 48
    Width = 80
    Height = 22
    Color = clBtnFace
    Enabled = False
    ItemHeight = 14
    TabOrder = 3
    Text = '0'
    DataType = dtReal
    Max = 1.000000000000000000
    ChangeDisabledColor = True
  end
  object btnCalc: TButton
    Left = 112
    Top = 128
    Width = 169
    Height = 25
    Caption = 'Calculate Argus Coordinates'
    TabOrder = 7
    OnClick = btnCalcClick
  end
  object btnClose: TBitBtn
    Left = 7
    Top = 128
    Width = 90
    Height = 25
    TabOrder = 6
    Kind = bkClose
  end
  object adeColumn: TArgusDataEntry
    Left = 112
    Top = 96
    Width = 80
    Height = 22
    Color = clBtnFace
    Enabled = False
    ItemHeight = 14
    TabOrder = 4
    Text = '0'
    DataType = dtInteger
    Max = 1.000000000000000000
    ChangeDisabledColor = True
  end
  object adeRow: TArgusDataEntry
    Left = 198
    Top = 96
    Width = 80
    Height = 22
    Color = clBtnFace
    Enabled = False
    ItemHeight = 14
    TabOrder = 5
    Text = '0'
    DataType = dtInteger
    Max = 1.000000000000000000
    ChangeDisabledColor = True
  end
end
