inherited frmSutraContourImporter: TfrmSutraContourImporter
  Left = 276
  Top = 285
  Width = 884
  Height = 424
  HelpContext = 1610
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Import SUTRA Contours from Spreadsheet'
  Font.Height = -16
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 876
    Height = 78
    Align = alBottom
    TabOrder = 0
    object lblRowCount: TLabel
      Left = 76
      Top = 9
      Width = 100
      Height = 19
      Caption = 'Number of rows'
    end
    object lblInstructions: TLabel
      Left = 352
      Top = 8
      Width = 216
      Height = 19
      Caption = 'Separate contours by an empty row'
    end
    object btnCancel: TBitBtn
      Left = 717
      Top = 4
      Width = 77
      Height = 28
      Hint = 'Quit without importing anything'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Kind = bkCancel
    end
    object btnNext: TBitBtn
      Left = 797
      Top = 4
      Width = 76
      Height = 28
      Hint = 'Go to the next step or finish'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnNextClick
      Kind = bkOK
      Layout = blGlyphRight
    end
    object seRowCount: TSpinEdit
      Left = 12
      Top = 4
      Width = 57
      Height = 29
      Hint = 'Specify the number of contours that you wish to import'
      MaxValue = 0
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Value = 0
      OnChange = seRowCountChange
    end
    object btnReadContours: TButton
      Left = 184
      Top = 4
      Width = 105
      Height = 28
      Caption = 'Read Contours'
      TabOrder = 3
      OnClick = btnReadContoursClick
    end
    object comboLayers: TComboBox
      Left = 12
      Top = 40
      Width = 421
      Height = 27
      Style = csDropDownList
      ItemHeight = 19
      TabOrder = 4
      OnChange = comboLayersChange
    end
  end
  object dg4Contours: TRbwDataGrid4
    Left = 0
    Top = 0
    Width = 876
    Height = 312
    Align = alClient
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    OnMouseDown = dg4ContoursMouseDown
    OnSelectCell = dg4ContoursSelectCell
    OnSetEditText = dg4ContoursSetEditText
    AutoDistributeText = True
    AutoIncreaseRowCount = True
    SelectedRowOrColumnColor = clAqua
    UnselectableColor = clBtnFace
    ColorRangeSelection = False
    ColorSelectedRow = True
    Columns = <
      item
        AutoAdjustRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -11
        ButtonFont.Name = 'MS Sans Serif'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustColWidths = False
      end
      item
        AutoAdjustRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -11
        ButtonFont.Name = 'MS Sans Serif'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustColWidths = False
      end
      item
        AutoAdjustRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -11
        ButtonFont.Name = 'MS Sans Serif'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustColWidths = False
      end
      item
        AutoAdjustRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -11
        ButtonFont.Name = 'MS Sans Serif'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustColWidths = False
      end
      item
        AutoAdjustRowHeights = False
        ButtonCaption = '...'
        ButtonFont.Charset = DEFAULT_CHARSET
        ButtonFont.Color = clWindowText
        ButtonFont.Height = -11
        ButtonFont.Name = 'MS Sans Serif'
        ButtonFont.Style = []
        ButtonUsed = False
        ButtonWidth = 20
        CheckMax = False
        CheckMin = False
        ComboUsed = False
        Format = rcf4String
        LimitToList = False
        MaxLength = 0
        ParentButtonFont = False
        WordWrapCaptions = False
        WordWrapCells = False
        AutoAdjustColWidths = False
      end>
  end
end
