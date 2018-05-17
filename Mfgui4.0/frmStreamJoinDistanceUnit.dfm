object frmStreamJoinDistance: TfrmStreamJoinDistance
  Left = 695
  Top = 228
  BorderStyle = bsDialog
  Caption = 'Distance'
  ClientHeight = 146
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 144
  TextHeight = 20
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 236
    Height = 60
    Caption = 
      'How close do the end points of two stream segments need to be fo' +
      'r them to be joined?'
    WordWrap = True
  end
  object adeDistance: TArgusDataEntry
    Left = 8
    Top = 80
    Width = 249
    Height = 22
    ItemHeight = 20
    TabOrder = 0
    Text = '0'
    DataType = dtReal
    Max = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 176
    Top = 112
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkClose
  end
end
