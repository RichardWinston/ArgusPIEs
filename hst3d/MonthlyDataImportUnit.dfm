object frmImport: TfrmImport
  Left = 681
  Top = 179
  Caption = 'Import Data'
  ClientHeight = 323
  ClientWidth = 449
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
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 8
    Width = 433
    Height = 145
    TabOrder = 0
    object rgItems: TRadioGroup
      Left = 0
      Top = 0
      Width = 417
      Height = 138
      Caption = 'Data set to import'
      TabOrder = 0
      OnClick = rgItemsClick
    end
  end
  object btnOK: TBitBtn
    Left = 368
    Top = 296
    Width = 75
    Height = 25
    TabOrder = 4
    OnClick = btnOKClick
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 288
    Top = 296
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 160
    Width = 433
    Height = 129
    Caption = 'Data sets to set to $N/A'
    TabOrder = 1
    object clbReset: TCheckListBox
      Left = 2
      Top = 16
      Width = 429
      Height = 111
      Align = alBottom
      ItemHeight = 14
      TabOrder = 0
    end
  end
  object BitBtn1: TBitBtn
    Left = 208
    Top = 296
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 2
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
      3333333333333FF3333333330000333333364463333333333333388F33333333
      00003333333E66433333333333338F38F3333333000033333333E66333333333
      33338FF8F3333333000033333333333333333333333338833333333300003333
      3333446333333333333333FF3333333300003333333666433333333333333888
      F333333300003333333E66433333333333338F38F333333300003333333E6664
      3333333333338F38F3333333000033333333E6664333333333338F338F333333
      0000333333333E6664333333333338F338F3333300003333344333E666433333
      333F338F338F3333000033336664333E664333333388F338F338F33300003333
      E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
      3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
      E333333333388FFFFF8333330000333333333333333333333333388888333333
      0000}
    NumGlyphs = 2
  end
  object dlgOpenImport: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'txt files|*.txt|All files|*.*'
    Left = 56
    Top = 296
  end
end
