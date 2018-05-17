object frmRowColPositions: TfrmRowColPositions
  Left = 490
  Top = 282
  Width = 417
  Height = 504
  HelpContext = 135
  Caption = 'frmRowColPositions'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 171
    Top = 0
    Width = 2
    Height = 436
    Cursor = crHSplit
  end
  inline FrameColPosition: TFramePosition
    Width = 171
    Height = 436
    Align = alLeft
    Font.Height = -15
    inherited dgPositions: TDataGrid
      Top = 82
      Width = 171
      Height = 354
      FixedCols = 0
      Columns = <
        item
          PickList.Strings = ()
          Title.WordWrap = False
        end
        item
          PickList.Strings = ()
          Title.WordWrap = False
        end>
      SelectedIndex = 0
    end
    inherited Panel1: TPanel
      Width = 171
      Height = 82
      inherited lblCount: TLabel
        Left = 61
        Width = 96
        Height = 34
      end
      inherited Label1: TLabel
        Left = 61
        Top = 35
        Width = 55
        Height = 17
      end
      inherited seCount: TSpinEdit
        Top = 7
        Width = 54
      end
      inherited Button1: TButton
        Left = 27
        Top = 56
        Width = 95
        Height = 21
      end
      inherited adeMultiplier: TArgusDataEntry
        Top = 34
        Width = 53
        Height = 18
        ItemHeight = 17
      end
    end
  end
  inline FrameRowPosition: TFramePosition
    Left = 173
    Width = 236
    Height = 436
    Align = alClient
    Font.Height = -15
    TabOrder = 1
    inherited dgPositions: TDataGrid
      Top = 82
      Width = 236
      Height = 354
      FixedCols = 0
      Columns = <
        item
          PickList.Strings = ()
          Title.WordWrap = False
        end
        item
          PickList.Strings = ()
          Title.WordWrap = False
        end>
      SelectedIndex = 0
    end
    inherited Panel1: TPanel
      Width = 236
      Height = 82
      inherited lblCount: TLabel
        Left = 63
        Width = 91
        Height = 34
        Caption = 'Number of row positions'
      end
      inherited Label1: TLabel
        Left = 61
        Top = 35
        Width = 55
        Height = 17
      end
      inherited seCount: TSpinEdit
        Top = 7
        Width = 54
      end
      inherited Button1: TButton
        Left = 27
        Top = 56
        Width = 95
        Height = 21
      end
      inherited adeMultiplier: TArgusDataEntry
        Top = 34
        Width = 53
        Height = 18
        ItemHeight = 17
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 436
    Width = 409
    Height = 34
    Align = alBottom
    TabOrder = 2
    object BitBtn1: TBitBtn
      Left = 340
      Top = 7
      Width = 63
      Height = 23
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 269
      Top = 7
      Width = 64
      Height = 23
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
    object BitBtn3: TBitBtn
      Left = 197
      Top = 7
      Width = 64
      Height = 23
      TabOrder = 2
      Kind = bkHelp
    end
  end
end
