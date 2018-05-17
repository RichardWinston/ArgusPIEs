inherited frmEditNew: TfrmEditNew
  Left = 728
  Top = 309
  Caption = 'Edit Contours'
  PixelsPerInch = 120
  TextHeight = 16
  inherited zbMain: TRbwZoomBox
    Height = 293
    VertScrollBar.Range = 289
    MaxY = 269
    OnPaint = zbMainPaint
    PBHeight = 289
  end
  inherited pnlBottom: TPanel
    Top = 293
    inherited sbZoomExtents: TSpeedButton
      Left = 28
    end
    inherited sbZoomIn: TSpeedButton
      Left = 52
    end
    inherited sbZoomOut: TSpeedButton
      Left = 76
    end
    inherited sbZoom: TSpeedButton
      Left = 100
    end
    inherited sbPan: TSpeedButton
      Left = 124
    end
    object sbSelect: TSpeedButton [5]
      Left = 4
      Top = 6
      Width = 23
      Height = 22
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
    end
    object BitBtn1: TBitBtn
      Left = 195
      Top = 6
      Width = 75
      Height = 22
      HelpContext = 10
      Anchors = [akTop, akRight]
      TabOrder = 2
      Kind = bkHelp
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 326
    Width = 432
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
end
