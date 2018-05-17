object frmRowColPositions: TfrmRowColPositions
  Left = 490
  Top = 282
  Width = 391
  Height = 504
  Caption = 'frmRowColPositions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 190
    Top = 0
    Width = 3
    Height = 436
    Cursor = crHSplit
  end
  inline FrameColPosition: TFramePosition
    Height = 436
    Align = alLeft
    inherited dgPositions: TDataGrid
      Height = 387
      FixedCols = 0
      Columns = <
        item
          PickList.Strings = ()
        end
        item
          PickList.Strings = ()
        end>
      SelectedIndex = 0
    end
  end
  inline FrameRowPosition: TFramePosition
    Left = 193
    Height = 436
    Align = alClient
    TabOrder = 1
    inherited dgPositions: TDataGrid
      Height = 387
      FixedCols = 0
      Columns = <
        item
          PickList.Strings = ()
        end
        item
          PickList.Strings = ()
        end>
      SelectedIndex = 0
    end
    inherited Panel1: TPanel
      inherited lblCount: TLabel
        Width = 143
        Caption = 'Number of row positions'
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 436
    Width = 383
    Height = 41
    Align = alBottom
    TabOrder = 2
    object BitBtn1: TBitBtn
      Left = 304
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 224
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
