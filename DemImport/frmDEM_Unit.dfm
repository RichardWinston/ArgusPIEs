object frmDEM2BMP: TfrmDEM2BMP
  Left = 395
  Top = 224
  Width = 519
  Height = 445
  Caption = 'Import DEM data in UTM coordinates'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
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
  TextHeight = 17
  object RbwZoomBox1: TRbwZoomBox
    Left = 0
    Top = 0
    Width = 511
    Height = 313
    HorzScrollBar.Range = 507
    VertScrollBar.Range = 309
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
    MinX = 20
    MaxX = 487
    MinY = 20
    MaxY = 289
    Multiplier = 1
    OnPaint = RbwZoomBox1Paint
    PBColor = clWindow
    PBCursor = crDefault
    PBDragCursor = crDrag
    PBDragKind = dkDrag
    PBDragMode = dmManual
    PBEnabled = True
    PBFont.Charset = ANSI_CHARSET
    PBFont.Color = clWindowText
    PBFont.Height = -15
    PBFont.Name = 'Times New Roman'
    PBFont.Style = []
    PBHeight = 309
    PBLeft = 0
    PBShowHint = False
    PBTag = 0
    PBTop = 0
    PBVisible = True
    PBWidth = 507
    SBrush.Style = bsClear
    SCursor = crDefault
    SDragCursor = crDrag
    SelectionWidth = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 313
    Width = 511
    Height = 57
    Align = alBottom
    TabOrder = 1
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
    object btnCancel: TBitBtn
      Left = 352
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      OnClick = btnCancelClick
      Kind = bkCancel
    end
    object cbWhiteOcean: TCheckBox95
      Left = 80
      Top = 8
      Width = 265
      Height = 22
      Alignment = taLeftJustify
      Caption = 'Make locations with elevations of 0 white'
      Checked = True
      State = cbChecked
      TabOrder = 1
      AlignmentBtn = taLeftJustify
      LikePushButton = False
      VerticalAlignment = vaTop
      WordWrap = False
    end
    object btnOK: TBitBtn
      Left = 432
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 2
      OnClick = btnOKClick
      Kind = bkOK
    end
    object cbRed: TCheckBox
      Left = 80
      Top = 33
      Width = 201
      Height = 17
      Caption = 'Make highest elevations red'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 370
    Width = 511
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 304
    Top = 72
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmap files (*.bmp)|*.bmp|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 336
    Top = 72
  end
  object MainMenu1: TMainMenu
    Left = 264
    Top = 72
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object Refresh1: TMenuItem
        Caption = 'Refresh'
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
end
