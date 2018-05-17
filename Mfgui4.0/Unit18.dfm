object Form18: TForm18
  Left = 0
  Top = 0
  Caption = 'Form18'
  ClientHeight = 341
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 160
    Top = 24
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 24
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 32
    Top = 80
    Width = 553
    Height = 233
    FixedCols = 0
    FixedRows = 0
    TabOrder = 1
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.ucn|*.ucn'
    Left = 112
    Top = 24
  end
end
