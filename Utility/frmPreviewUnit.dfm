object frmPreview: TfrmPreview
  Left = 352
  Top = 190
  HelpContext = 185
  Caption = 'Preview'
  ClientHeight = 395
  ClientWidth = 639
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 20
  object sgPreview: TDataGrid
    Left = 0
    Top = 69
    Width = 639
    Height = 263
    Align = alClient
    ColCount = 2
    DefaultRowHeight = 20
    RowCount = 2
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Courier'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goEditing]
    ParentFont = False
    TabOrder = 1
    OnDrawCell = sgPreviewDrawCell
    OnMouseMove = sgPreviewMouseMove
    OnMouseUp = sgPreview1MouseUp
    OnSelectCell = sgPreviewSelectCell
    Columns = <
      item
        Title.Alignment = taRightJustify
        Title.WordWrap = False
      end
      item
        Title.WordWrap = False
      end>
    RowCountMin = 0
    SelectedIndex = 1
    Version = '2.0'
    ExplicitWidth = 642
    ColWidths = (
      30
      595)
  end
  object Panel1: TPanel
    Left = 0
    Top = 332
    Width = 639
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 642
    DesignSize = (
      639
      44)
    object lblMultiplier: TLabel
      Left = 101
      Top = 11
      Width = 69
      Height = 20
      Caption = 'Multiplier'
      Visible = False
    end
    object btnNext: TBitBtn
      Left = 542
      Top = 6
      Width = 91
      Height = 29
      Anchors = [akTop, akRight]
      Caption = '&Next'
      TabOrder = 3
      OnClick = btnNextClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      Layout = blGlyphRight
      NumGlyphs = 2
    end
    object btnBack: TBitBtn
      Left = 448
      Top = 6
      Width = 93
      Height = 29
      Anchors = [akTop, akRight]
      Caption = '&Back'
      Enabled = False
      TabOrder = 2
      OnClick = btnBackClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object btnCancel: TBitBtn
      Left = 353
      Top = 6
      Width = 93
      Height = 29
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
      Kind = bkCancel
    end
    object BitBtn1: TBitBtn
      Left = 261
      Top = 6
      Width = 91
      Height = 29
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkHelp
    end
    object adeMultiplier: TArgusDataEntry
      Left = 9
      Top = 9
      Width = 85
      Height = 22
      ItemHeight = 20
      TabOrder = 4
      Text = '1'
      Visible = False
      OnEnter = adeMultiplierEnter
      DataType = dtReal
      Max = 1.000000000000000000
      ChangeDisabledColor = True
    end
  end
  object pnlInstructions: TPanel
    Left = 0
    Top = 0
    Width = 639
    Height = 69
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 642
    DesignSize = (
      639
      69)
    object lblInstructions: TLabel
      Left = 107
      Top = 14
      Width = 373
      Height = 40
      Alignment = taCenter
      Anchors = [akTop]
      Caption = 
        'Click on the column headings of the table to add or remove a sep' +
        'arator'
      WordWrap = True
      ExplicitLeft = 108
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 376
    Width = 639
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitWidth = 642
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 16
    Top = 16
  end
end
