object frmWellData: TfrmWellData
  Left = 387
  Top = 221
  Width = 631
  Height = 444
  HelpContext = 1600
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Well Data'
  Color = clBtnFace
  Constraints.MinHeight = 125
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 19
  object sgWellData: TStringGrid
    Left = 0
    Top = 0
    Width = 623
    Height = 310
    HelpContext = 1600
    Align = alClient
    ColCount = 9
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goColMoving, goEditing]
    TabOrder = 0
    OnColumnMoved = sgWellDataColumnMoved
    ColWidths = (
      64
      64
      64
      80
      86
      64
      64
      64
      64)
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 310
    Width = 623
    Height = 100
    HelpContext = 1600
    Align = alBottom
    TabOrder = 1
    object lblWell: TLabel
      Left = 8
      Top = 4
      Width = 78
      Height = 38
      Caption = 'Number of Wells'
      WordWrap = True
    end
    object lblUnit: TLabel
      Left = 88
      Top = 4
      Width = 64
      Height = 38
      Caption = 'Geologic Unit'
      WordWrap = True
    end
    object btnOK: TBitBtn
      Left = 541
      Top = 68
      Width = 75
      Height = 25
      HelpContext = 1600
      Anchors = [akTop, akRight]
      TabOrder = 0
      OnClick = btnOKClick
      Kind = bkOK
    end
    object btnCancel: TBitBtn
      Left = 461
      Top = 68
      Width = 75
      Height = 25
      HelpContext = 1600
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
    object adeWellCount: TArgusDataEntry
      Left = 8
      Top = 42
      Width = 49
      Height = 22
      HelpContext = 1600
      ItemHeight = 19
      TabOrder = 2
      Text = '1'
      OnExit = adeWellCountExit
      DataType = dtInteger
      Max = 1
      Min = 1
      CheckMin = True
      ChangeDisabledColor = True
    end
    object btnHelp: TBitBtn
      Left = 381
      Top = 68
      Width = 75
      Height = 25
      HelpContext = 1600
      Anchors = [akTop, akRight]
      TabOrder = 3
      Kind = bkHelp
    end
    object adeUnit: TArgusDataEntry
      Left = 88
      Top = 42
      Width = 49
      Height = 22
      HelpContext = 1600
      ItemHeight = 19
      TabOrder = 4
      Text = '1'
      DataType = dtInteger
      Max = 1
      Min = 1
      CheckMax = True
      CheckMin = True
      ChangeDisabledColor = True
    end
    object rgDataFormat: TRadioGroup
      Left = 168
      Top = 8
      Width = 209
      Height = 89
      HelpContext = 1600
      Caption = 'Data Format'
      ItemIndex = 0
      Items.Strings = (
        'Tab-delimited'
        'Comma, space-delimited')
      TabOrder = 5
    end
    object cbMultUnits: TCheckBox
      Left = 8
      Top = 72
      Width = 153
      Height = 17
      Caption = 'Use Multiple Units'
      TabOrder = 6
      OnClick = cbMultUnitsClick
    end
    object btnPaste: TBitBtn
      Left = 461
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Paste from clipboard'
      Anchors = [akTop, akRight]
      Caption = '&Paste'
      TabOrder = 7
      OnClick = btnPasteClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333330FFFFF
        FFF03333337F3FFFF3F73333330F0000F0F03333337F777737373333330FFFFF
        FFF033FFFF7FFF33FFF77000000007F00000377777777FF777770BBBBBBBB0F0
        FF037777777777F7F3730B77777BB0F0F0337777777777F7F7330B7FFFFFB0F0
        0333777F333377F77F330B7FFFFFB0009333777F333377777FF30B7FFFFFB039
        9933777F333377F777FF0B7FFFFFB0999993777F33337777777F0B7FFFFFB999
        9999777F3333777777770B7FFFFFB0399933777FFFFF77F777F3070077007039
        99337777777777F777F30B770077B039993377FFFFFF77F777330BB7007BB999
        93337777FF777777733370000000073333333777777773333333}
      NumGlyphs = 2
    end
    object btnFile: TBitBtn
      Left = 541
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Read from file'
      Anchors = [akTop, akRight]
      Caption = '&Open'
      TabOrder = 8
      OnClick = btnFileClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
        07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
        0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
    end
  end
  object odRead: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All Files|*.*'
    Left = 48
    Top = 256
  end
end
