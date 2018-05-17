object CoordForm: TCoordForm
  Left = 441
  Top = 209
  Caption = 'Coordinate System'
  ClientHeight = 93
  ClientWidth = 260
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
  object rgCoord: TRadioGroup
    Left = 6
    Top = 8
    Width = 243
    Height = 41
    Hint = '1.4 CYLIND'
    Caption = 'Coordinate System'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Cartesian'
      'Cylindrical')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = rgCoordClick
  end
  object BitBtn1: TBitBtn
    Left = 90
    Top = 56
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
end
