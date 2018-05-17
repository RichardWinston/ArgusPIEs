object frmRowColumnDivision: TfrmRowColumnDivision
  Left = 213
  Top = 116
  Width = 186
  Height = 176
  Caption = 'Rows and Columns'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 56
    Top = 3
    Width = 93
    Height = 16
    Caption = 'Number of rows'
  end
  object Label2: TLabel
    Left = 56
    Top = 27
    Width = 115
    Height = 16
    Caption = 'Number of columns'
  end
  object Label3: TLabel
    Left = 0
    Top = 48
    Width = 167
    Height = 64
    Caption = 
      'Set the number of rows and columns into which you wish each of t' +
      'he selected rows and columns to be divided'
    WordWrap = True
  end
  object adeRowCount: TArgusDataEntry
    Left = 0
    Top = 0
    Width = 49
    Height = 22
    ItemHeight = 16
    TabOrder = 0
    Text = '1'
    DataType = dtInteger
    Max = 1
    Min = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object adeColCount: TArgusDataEntry
    Left = 0
    Top = 24
    Width = 49
    Height = 22
    ItemHeight = 16
    TabOrder = 1
    Text = '1'
    DataType = dtInteger
    Max = 1
    Min = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 120
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 96
    Top = 120
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
end
