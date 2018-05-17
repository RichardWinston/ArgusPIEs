inherited frmEditNew: TfrmEditNew
  Left = 728
  Top = 309
  Caption = 'frmEditNew'
  PixelsPerInch = 120
  TextHeight = 16
  inherited zbMain: TRBWZoomBox
    Height = 293
  end
  inherited pnlBottom: TPanel
    Top = 293
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
