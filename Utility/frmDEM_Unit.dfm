object frmDEM2BMP: TfrmDEM2BMP
  Left = 395
  Top = 224
  HelpContext = 210
  Caption = 'Import DEM data in UTM coordinates'
  ClientHeight = 405
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 19
  object RbwZoomBox1: TRbwZoomBox
    Left = 0
    Top = 0
    Width = 574
    Height = 274
    HorzScrollBar.Range = 559
    VertScrollBar.Range = 295
    Align = alClient
    AutoScroll = False
    Color = clWindow
    ParentColor = False
    TabOrder = 0
    OnMouseDown = RbwZoomBox1MouseDown
    OnMouseMove = RbwZoomBox1MouseMove
    OnMouseUp = RbwZoomBox1MouseUp
    BottomMargin = 20
    LeftMargin = 20
    RightMargin = 20
    TopMargin = 20
    MinX = 20.000000000000000000
    MaxX = 518.000000000000000000
    MinY = 20.000000000000000000
    MaxY = 229.000000000000000000
    Multiplier = 1.000000000000000000
    OnPaint = RbwZoomBox1Paint
    PBColor = clWindow
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
    PBHeight = 249
    PBLeft = 0
    PBShowHint = False
    PBTag = 0
    PBTop = 0
    PBVisible = True
    PBWidth = 538
    SBrush.Style = bsClear
    SCursor = crDefault
    SDragCursor = crDrag
    SelectionWidth = 3
    ExplicitWidth = 563
  end
  object Panel1: TPanel
    Left = 0
    Top = 274
    Width = 574
    Height = 112
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 563
    DesignSize = (
      574
      112)
    object sbPan: TSpeedButton
      Left = 56
      Top = 8
      Width = 23
      Height = 22
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
    object sbZoomExtents: TSpeedButton
      Left = 32
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Zoom out all the way'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        333333773337777333333078F8F87033333337F33FFF37F33333778F999F8773
        333337337773373F333307F898F8F70333337F337FF3337F3333078F998F8703
        33337F337733337F333307F898F8F703333373F37FFF33733333778F999F8773
        333337F3777337F333333078F8F870333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbZoomExtentsClick
    end
    object sbZoomOut: TSpeedButton
      Left = 8
      Top = 30
      Width = 23
      Height = 22
      Hint = 'Zoom out'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        333333773337777333333078F8F87033333337F3333337F33333778F8F8F8773
        333337333333373F333307F8F8F8F70333337F33FFFFF37F3333078999998703
        33337F377777337F333307F8F8F8F703333373F3333333733333778F8F8F8773
        333337F3333337F333333078F8F870333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbZoomOutClick
    end
    object sbZoomIn: TSpeedButton
      Left = 32
      Top = 30
      Width = 23
      Height = 22
      Hint = 'Zoom in'
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
    object sbZoom: TSpeedButton
      Left = 8
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Zoom'
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
        333333773337777333333078F8F87033333337F3333337F33333778F8F8F8773
        333337333333373F333307F8F8F8F70333337F333333337F3333078F8F8F8703
        33337F333333337F333307F8F8F8F703333373F3333333733333778F8F8F8773
        333337F3333337F333333078F8F870333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbZoomClick
    end
    object Label1: TLabel
      Left = 8
      Top = 84
      Width = 98
      Height = 19
      Caption = 'Color Scheme'
    end
    object PaintBoxColorBar: TPaintBox
      Left = 327
      Top = 81
      Width = 242
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      OnPaint = PaintBoxColorBarPaint
    end
    object btnCancel: TBitBtn
      Left = 399
      Top = 48
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 4
      OnClick = btnCancelClick
      Kind = bkCancel
    end
    object cbWhiteOcean: TCheckBox95
      Left = 80
      Top = 8
      Width = 321
      Height = 22
      Alignment = taLeftJustify
      Caption = 'Make locations with elevations of 0 white'
      Checked = True
      State = cbChecked
      TabOrder = 0
      WordWrap = False
      AlignmentBtn = taLeftJustify
      LikePushButton = False
      VerticalAlignment = vaTop
    end
    object btnOK: TBitBtn
      Left = 479
      Top = 48
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 5
      OnClick = btnOKClick
      Kind = bkOK
    end
    object cbRed: TCheckBox
      Left = 80
      Top = 29
      Width = 313
      Height = 22
      Caption = 'Reverse color scheme'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = cbRedClick
    end
    object BitBtn1: TBitBtn
      Left = 479
      Top = 20
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 2
      Kind = bkHelp
    end
    object btnAbout: TButton
      Left = 399
      Top = 20
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'About'
      TabOrder = 1
      OnClick = btnAboutClick
    end
    object cbIgnore: TCheckBox
      Left = 80
      Top = 49
      Width = 209
      Height = 22
      Caption = 'Ignore elevations coded as'
      TabOrder = 6
      OnClick = cbIgnoreClick
    end
    object adeIgnore: TArgusDataEntry
      Left = 296
      Top = 49
      Width = 89
      Height = 22
      Color = clBtnFace
      Enabled = False
      ItemHeight = 19
      TabOrder = 7
      Text = '-32767'
      DataType = dtInteger
      Max = 32767.000000000000000000
      Min = -32768.000000000000000000
      CheckMax = True
      CheckMin = True
      ChangeDisabledColor = True
    end
    object comboColorScheme: TComboBox
      Left = 120
      Top = 80
      Width = 201
      Height = 27
      Style = csDropDownList
      ItemHeight = 19
      TabOrder = 8
      OnChange = comboColorSchemeChange
      Items.Strings = (
        'Spectrum'
        'Green to Magenta'
        'Blue to Red'
        'Blue to Dark Orange'
        'Blue to Green'
        'Brown to Blue'
        'Blue to Gray'
        'Blue to Orange'
        'Blue to Orange Red'
        'Light Blue to Dark Blue')
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 386
    Width = 574
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
    ParentFont = True
    UseSystemFont = False
    ExplicitWidth = 563
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 72
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmap files (*.bmp)|*.bmp|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 104
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open DEM'
        OnClick = Open1Click
      end
      object Refresh1: TMenuItem
        Caption = 'Refresh DEM'
        OnClick = Refresh1Click
      end
      object Save1: TMenuItem
        Caption = 'Save as BMP'
        OnClick = Save1Click
      end
      object SaveasJPEG1: TMenuItem
        Caption = 'Save as JPEG'
        OnClick = SaveasJPEG1Click
      end
      object ImportfromInformationLayer1: TMenuItem
        Caption = 'Import from Information Layer'
        OnClick = ImportfromInformationLayer1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Help2: TMenuItem
        Caption = 'Help'
        OnClick = Help2Click
      end
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object qtBlocksElements: TRbwQuadTree
    MaxPoints = 100
    Left = 138
    Top = 18
  end
  object qtNodes: TRbwQuadTree
    MaxPoints = 100
    Left = 170
    Top = 18
  end
end
