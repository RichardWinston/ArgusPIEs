inherited frmMeshToContour: TfrmMeshToContour
  HelpContext = 270
  Caption = 'Mesh Objects To Contours'
  ClientHeight = 340
  ClientWidth = 471
  ExplicitWidth = 489
  ExplicitHeight = 385
  PixelsPerInch = 120
  TextHeight = 19
  inherited zbMain: TRbwZoomBox
    Width = 471
    Height = 307
    HorzScrollBar.Range = 453
    VertScrollBar.Range = 303
    MaxX = 433.000000000000000000
    MaxY = 283.000000000000000000
    OnPaint = zbMainPaint
    PBFont.Height = -9
    PBHeight = 303
    PBWidth = 453
    ExplicitWidth = 457
    ExplicitHeight = 307
  end
  inherited pnlBottom: TPanel
    Top = 307
    Width = 471
    ExplicitTop = 307
    ExplicitWidth = 457
    inherited sbZoomExtents: TSpeedButton
      Left = 49
      ExplicitLeft = 49
    end
    inherited sbZoomIn: TSpeedButton
      Left = 72
      ExplicitLeft = 72
    end
    inherited sbZoomOut: TSpeedButton
      Left = 95
      ExplicitLeft = 95
    end
    inherited sbZoom: TSpeedButton
      Left = 118
      ExplicitLeft = 118
    end
    inherited sbPan: TSpeedButton
      Left = 141
      ExplicitLeft = 141
    end
    object sbLasso: TSpeedButton [5]
      Left = 26
      Top = 5
      Width = 23
      Height = 22
      Hint = 'outline node or edges to select them'
      GroupIndex = 1
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCFFFFFCCCCCCCCCC00000CCC
        CCCCCCCC77777CCCCCCCCC00CCCCCCCCCCCCCC77CCCCCCCCCCCCCC0CCCCCCCCC
        CCCCCC7FCCCCCCCCCCCCCC0CCCCCCCCCCCCCCC7FFFFFCCCCCCCCCC000000CCCC
        CCCCCC777777FFFCCCCCCCCC0CCC000CCCCCCCCC7CCC777FCCCCCCC0CCCCCCC0
        CCCCCCC7CCCCCCC7FCCCCC0CCCCCCCCC0CCCCC7FCCCCCCCC7FFCCC0CCCCCCCCC
        C0CCCC7FCCCCCCCCC7CCCC0CCCCCCCCC0CCCCC7FCCCCCFFF7CCCCC0CCCCCC000
        CCCCCC7FFFFFF777CCCCCCC000000CCCCCCCCCC777777CCCCCCCCCCCCCCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
    end
    object sbSelect: TSpeedButton [6]
      Left = 3
      Top = 5
      Width = 23
      Height = 22
      Hint = 'Select node or edges'
      GroupIndex = 1
      Down = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333FFF3333333333333707333333333333F777F3333333333370
        9033333333F33F7737F33333373337090733333337F3F7737733333330037090
        73333333377F7737733333333090090733333333373773773333333309999073
        333333337F333773333333330999903333333333733337F33333333099999903
        33333337F3333F7FF33333309999900733333337333FF7773333330999900333
        3333337F3FF7733333333309900333333333337FF77333333333309003333333
        333337F773333333333330033333333333333773333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
    end
    inherited btnOK: TBitBtn
      Left = 392
      Width = 73
      TabOrder = 3
      OnClick = btnOKClick
      ExplicitLeft = 392
      ExplicitWidth = 73
    end
    inherited btnCancel: TBitBtn
      Left = 312
      Width = 73
      TabOrder = 2
      ExplicitLeft = 312
      ExplicitWidth = 73
    end
    inherited BitBtn1: TBitBtn
      Left = 232
      Width = 73
      TabOrder = 1
      ExplicitLeft = 232
      ExplicitWidth = 73
    end
    object btnAbout: TButton
      Left = 168
      Top = 5
      Width = 60
      Height = 25
      Caption = 'About'
      TabOrder = 0
      OnClick = btnAboutClick
    end
  end
  object timerLasso: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timerLassoTimer
    Left = 34
    Top = 10
  end
end
