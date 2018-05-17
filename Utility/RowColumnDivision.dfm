object frmRowColumnDivision: TfrmRowColumnDivision
  Left = 213
  Top = 116
  HelpContext = 130
  Caption = 'Rows and Columns'
  ClientHeight = 183
  ClientWidth = 247
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 19
  object Label1: TLabel
    Left = 54
    Top = 10
    Width = 111
    Height = 19
    Caption = 'Number of rows'
  end
  object Label2: TLabel
    Left = 46
    Top = 38
    Width = 136
    Height = 19
    Caption = 'Number of columns'
  end
  object Label3: TLabel
    Left = 4
    Top = 63
    Width = 236
    Height = 76
    Caption = 
      'Set the number of rows and columns into which you wish each of t' +
      'he selected rows and columns to be divided.'
    WordWrap = True
  end
  object adeRowCount: TArgusDataEntry
    Left = 4
    Top = 8
    Width = 40
    Height = 22
    ItemHeight = 19
    TabOrder = 0
    Text = '1'
    DataType = dtInteger
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object adeColCount: TArgusDataEntry
    Left = 4
    Top = 36
    Width = 40
    Height = 22
    ItemHeight = 19
    TabOrder = 1
    Text = '1'
    DataType = dtInteger
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 85
    Top = 151
    Width = 76
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 166
    Top = 151
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkOK
  end
  object BitBtn3: TBitBtn
    Left = 5
    Top = 151
    Width = 76
    Height = 25
    TabOrder = 2
    Kind = bkHelp
  end
end
