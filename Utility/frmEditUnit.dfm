inherited frmEditNew: TfrmEditNew
  Left = 728
  Top = 309
  HelpContext = 100
  Caption = 'Edit Contours'
  ClientWidth = 449
  ExplicitWidth = 467
  PixelsPerInch = 120
  TextHeight = 19
  inherited zbMain: TRbwZoomBox
    Width = 449
    Height = 275
    HorzScrollBar.Range = 445
    VertScrollBar.Range = 271
    MaxX = 425.000000000000000000
    MaxY = 251.000000000000000000
    OnPaint = zbMainPaint
    PBFont.Height = -9
    PBHeight = 271
    PBWidth = 445
    ExplicitWidth = 449
    ExplicitHeight = 275
  end
  inherited pnlBottom: TPanel
    Top = 275
    Width = 449
    ExplicitTop = 275
    ExplicitWidth = 449
    inherited sbZoomExtents: TSpeedButton
      Left = 49
      ExplicitLeft = 49
    end
    inherited sbZoomIn: TSpeedButton
      Left = 26
      ExplicitLeft = 26
    end
    object sbSelect: TSpeedButton [5]
      Left = 3
      Top = 5
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
    inherited btnOK: TBitBtn
      TabOrder = 3
    end
    inherited btnCancel: TBitBtn
      Left = 285
      TabOrder = 2
      ExplicitLeft = 285
    end
    inherited BitBtn1: TBitBtn
      Left = 206
      TabOrder = 1
      ExplicitLeft = 206
    end
    object btnAbout: TButton
      Left = 144
      Top = 5
      Width = 57
      Height = 25
      Caption = 'About'
      TabOrder = 0
      OnClick = btnAboutClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 308
    Width = 449
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end>
  end
end
