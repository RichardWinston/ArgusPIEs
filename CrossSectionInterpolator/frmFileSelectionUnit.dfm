inherited frmFileSelection: TfrmFileSelection
  Width = 522
  Height = 337
  Caption = 'Select Shape Files to Import'
  Font.Height = -17
  PixelsPerInch = 120
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 514
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnDelete: TButton
      Left = 112
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Remove File'
      TabOrder = 0
      OnClick = btnDeleteClick
    end
    object BitBtn1: TBitBtn
      Left = 416
      Top = 8
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
    object BitBtn2: TBitBtn
      Left = 319
      Top = 8
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Next'
      Default = True
      ModalResult = 1
      TabOrder = 2
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
      NumGlyphs = 2
    end
    object btnSelect: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Select Files'
      TabOrder = 3
      OnClick = btnSelectClick
    end
  end
  object rdg2FileNames: TRbwDataGrid2
    Left = 0
    Top = 0
    Width = 514
    Height = 264
    Align = alClient
    ColCount = 3
    DefaultColWidth = 104
    FixedCols = 1
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    OnSelectCell = rdg2FileNamesSelectCell
    OnSetEditText = rdg2FileNamesSetEditText
    AutoDistributeText = False
    ColorSelectedRow = True
    Columns = <
      item
        CheckMax = False
        CheckMin = False
        Format = rcf2String
        LimitToList = False
        MaxLength = 0
        UseButton = False
        ButtonCaption = '...'
        ButtonWidth = 20
        AutoAdjustColWidths = True
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustRowHeights = False
      end
      item
        CheckMax = False
        CheckMin = False
        Format = rcf2String
        LimitToList = False
        MaxLength = 0
        UseButton = False
        ButtonCaption = '...'
        ButtonWidth = 20
        AutoAdjustColWidths = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustRowHeights = False
      end
      item
        CheckMax = False
        CheckMin = False
        Format = rcf2Combo
        LimitToList = True
        MaxLength = 0
        UseButton = False
        ButtonCaption = '...'
        ButtonWidth = 20
        AutoAdjustColWidths = True
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustRowHeights = False
      end>
    SelectedRowColor = clAqua
    WordWrapColTitles = False
    UnselectableColor = clBtnFace
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Shape Files (*.shp)|*.shp|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 16
    Top = 24
  end
  object XBase1: TXBase
    Active = False
    AutoUpDate = True
    DebugErr = False
    Deleted = False
    Left = 56
    Top = 24
  end
end
