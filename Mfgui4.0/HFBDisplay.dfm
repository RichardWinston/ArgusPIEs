object frmHFBDisplay: TfrmHFBDisplay
  Left = 542
  Top = 187
  Width = 551
  Height = 423
  HelpContext = 10010
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Display Horizontal-Flow Barriers'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseMove = MouseMoved
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 305
    Width = 543
    Height = 84
    HelpContext = 10010
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseMove = MouseMoved
    object Label1: TLabel
      Left = 66
      Top = 5
      Width = 89
      Height = 19
      Caption = 'Unit Number'
    end
    object sbZoomIn: TSpeedButton
      Left = 216
      Top = 56
      Width = 24
      Height = 25
      Hint = 'Zoom In'
      AllowAllUp = True
      GroupIndex = 1
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
        3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
        33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
        333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbZoomInClick
    end
    object sbZoomOut: TSpeedButton
      Left = 240
      Top = 56
      Width = 24
      Height = 25
      Hint = 'Zoom Out'
      AllowAllUp = True
      GroupIndex = 1
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        333333773337777333333078F8F87033333337F33FFF37F33333778F000F8773
        333337337773373F333307F808F8F70333337F337FF3337F3333078F008F8703
        33337F337733337F333307F808F8F703333373F37FFF33733333778F000F8773
        333337F3777337F333333078F8F870333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbZoomOutClick
    end
    object sbPan: TSpeedButton
      Left = 264
      Top = 56
      Width = 24
      Height = 25
      Hint = 'Pan'
      AllowAllUp = True
      GroupIndex = 1
      Enabled = False
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDDDDDDD44444444DDDDDDDD0FFFFFF0DDDDDDD0FFFFFFFF0DDDDD0FFFFFFFF
        F0DDDDD0FFFFFFFFF0DDDD0FF0FFFFFFF0DDD0FF00F0F0F0F0DDD000D0F0F0F0
        F0DDDDDDD0F0F0F0F0DDDDDDD0F0F0F0F0DDDDDDD0F0F0F00DDDDDDDD0F0F0F0
        DDDDDDDDDD00F00DDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDD}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbPanClick
    end
    object adeHFBLayer: TArgusDataEntry
      Left = 2
      Top = 1
      Width = 57
      Height = 22
      HelpContext = 10010
      ItemHeight = 19
      TabOrder = 0
      Text = '1'
      DataType = dtInteger
      Max = 1
      Min = 1
      CheckMax = True
      CheckMin = True
      ChangeDisabledColor = True
    end
    object btnDisplay: TButton
      Left = 304
      Top = 56
      Width = 75
      Height = 25
      HelpContext = 10010
      Caption = '&Display'
      TabOrder = 1
      OnClick = btnDisplayClick
    end
    object bitbtnClose: TBitBtn
      Left = 464
      Top = 56
      Width = 75
      Height = 25
      HelpContext = 10010
      TabOrder = 2
      Kind = bkClose
    end
    object btnHelp: TBitBtn
      Left = 384
      Top = 56
      Width = 75
      Height = 25
      HelpContext = 10010
      TabOrder = 3
      Kind = bkHelp
    end
    object cbXPos: TCheckBox
      Left = 2
      Top = 28
      Width = 103
      Height = 17
      Caption = 'X Positive'
      Checked = True
      State = cbChecked
      TabOrder = 4
      Visible = False
      OnClick = cbXPosClick
    end
    object cbYPos: TCheckBox
      Left = 2
      Top = 44
      Width = 95
      Height = 17
      Caption = 'Y Positive'
      TabOrder = 5
      Visible = False
      OnClick = cbYPosClick
    end
    object btnSave: TRbw95Button
      Left = 304
      Top = 8
      Width = 75
      Height = 41
      Caption = 'Save as image'
      TabOrder = 6
      OnClick = btnSaveClick
      Alignment = taCenter
      VerticalAlignment = vaCenter
      Flat = False
      WordWrap = True
    end
    object btnPrint: TButton
      Left = 384
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Print...'
      TabOrder = 7
      OnClick = btnPrintClick
    end
  end
  object zbHFB_Display: TRbwZoomBox
    Left = 0
    Top = 0
    Width = 543
    Height = 305
    HorzScrollBar.Range = 539
    VertScrollBar.Range = 301
    Align = alClient
    AutoScroll = False
    TabOrder = 1
    OnMouseDown = zbHFB_DisplayMouseDown
    OnMouseMove = zbHFB_DisplayMouseMove
    OnMouseUp = zbHFB_DisplayMouseUp
    BottomMargin = 20
    LeftMargin = 20
    RightMargin = 20
    TopMargin = 20
    MinX = 20
    MaxX = 519
    MinY = 20
    MaxY = 281
    Multiplier = 1
    OnPaint = zbHFB_DisplayPaint
    PBColor = clBtnFace
    PBCursor = crDefault
    PBDragCursor = crDrag
    PBDragKind = dkDrag
    PBDragMode = dmManual
    PBEnabled = True
    PBFont.Charset = ANSI_CHARSET
    PBFont.Color = clWindowText
    PBFont.Height = -17
    PBFont.Name = 'Times New Roman'
    PBFont.Style = []
    PBHeight = 301
    PBLeft = 0
    PBShowHint = False
    PBTag = 0
    PBTop = 0
    PBVisible = True
    PBWidth = 539
    SBrush.Style = bsClear
    SCursor = crDefault
    SDragCursor = crDrag
    SelectionWidth = 3
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'emf'
    Filter = 
      'Enhanced Windows Metafiles (*.emf)|*.emf|Windows Metafiles (*.wm' +
      'f)|*.wmf|Bitmaps (*.bmp)|*.bmp'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = SaveDialog1TypeChange
    Left = 34
    Top = 42
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 74
    Top = 50
  end
  object PrintDialog1: TPrintDialog
    Left = 114
    Top = 50
  end
end
