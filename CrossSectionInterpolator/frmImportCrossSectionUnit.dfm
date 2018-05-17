inherited frmImportCrossSection: TfrmImportCrossSection
  Caption = 'Import Cross Section'
  ClientHeight = 485
  ClientWidth = 567
  Font.Height = -17
  ExplicitWidth = 575
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 444
    Width = 567
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      567
      41)
    object btnNext: TBitBtn
      Left = 472
      Top = 8
      Width = 83
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Next'
      TabOrder = 0
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
      NumGlyphs = 2
    end
    object btnBack: TBitBtn
      Left = 384
      Top = 8
      Width = 83
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Back'
      Enabled = False
      TabOrder = 1
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
    object BitBtn1: TBitBtn
      Left = 296
      Top = 8
      Width = 83
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 2
      Kind = bkCancel
    end
  end
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 567
    Height = 444
    ActivePage = tabGraphical
    Align = alClient
    TabOrder = 1
    object tabCrossSectionLocations: TTabSheet
      Caption = 'Cross Section Locations'
      ImageIndex = 1
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object rdg2Locations: TRbwDataGrid2
        Left = 0
        Top = 0
        Width = 559
        Height = 393
        Align = alClient
        DefaultColWidth = 65
        FixedCols = 1
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowMoving, goEditing]
        TabOrder = 0
        AutoDistributeText = True
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
            Format = rcf2Real
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
            Format = rcf2Real
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
            Format = rcf2Real
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
            Format = rcf2Real
            LimitToList = False
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
      object Panel2: TPanel
        Left = 0
        Top = 393
        Width = 559
        Height = 41
        Align = alBottom
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 540
          Height = 19
          Caption = 
            'Click on a section name and drag it to rearrange the order of th' +
            'e sections.'
        end
      end
    end
    object tabGraphical: TTabSheet
      Caption = 'Graphical'
      TabVisible = False
      object zbCrossSections: TRbwZoomBox
        Left = 169
        Top = 0
        Width = 390
        Height = 434
        HorzScrollBar.Range = 386
        VertScrollBar.Range = 430
        Align = alClient
        AutoScroll = False
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        OnMouseUp = zbCrossSectionsMouseUp
        OnResize = zbCrossSectionsResize
        BottomMargin = 20
        LeftMargin = 20
        RightMargin = 20
        TopMargin = 20
        MinX = 20.000000000000000000
        MaxX = 366.000000000000000000
        MinY = 20.000000000000000000
        MaxY = 410.000000000000000000
        Multiplier = 1.000000000000000000
        OnPaint = zbCrossSectionsPaint
        PBColor = clWindow
        PBCursor = crDefault
        PBDragCursor = crDrag
        PBDragKind = dkDrag
        PBDragMode = dmManual
        PBEnabled = True
        PBFont.Charset = ANSI_CHARSET
        PBFont.Color = clWindowText
        PBFont.Height = -17
        PBFont.Name = 'Arial'
        PBFont.Style = []
        PBHeight = 430
        PBLeft = 0
        PBShowHint = False
        PBTag = 0
        PBTop = 0
        PBVisible = True
        PBWidth = 386
        SBrush.Style = bsClear
        SCursor = crDefault
        SDragCursor = crDrag
        SelectionWidth = 3
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 169
        Height = 434
        Align = alLeft
        TabOrder = 1
        object Label2: TLabel
          Left = 8
          Top = 8
          Width = 152
          Height = 19
          Caption = 'Upper Cross Section'
        end
        object Label3: TLabel
          Left = 8
          Top = 64
          Width = 152
          Height = 19
          Caption = 'Lower Cross Section'
        end
        object Label4: TLabel
          Left = 8
          Top = 128
          Width = 31
          Height = 19
          Caption = 'Line'
        end
        object btnSelect: TSpeedButton
          Left = 8
          Top = 192
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
        object btnDelete: TSpeedButton
          Left = 40
          Top = 192
          Width = 23
          Height = 22
          GroupIndex = 1
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300333333333
            33003FF33333333333FF370033333333300737FF333333333FF7337003333333
            0073337FF3333333FF7333370033333007333337FF33333FF733333370033300
            733333337FF333FF73333333370030073333333337FF3FF73333333333700073
            33333333337FFF73333333333330003333333333333FFF333333333333007003
            3333333333FF7FF33333333330073700333333333FF737FF3333333300733370
            03333333FF73337FF3333330073333370033333FF7333337FF33330073333333
            700333FF733333337FF330073333333337003FF73333333337FF307333333333
            33703F7333333333337F37333333333333373733333333333337}
          NumGlyphs = 2
          OnClick = btnDeleteClick
        end
        object comboLowerCrossSec: TComboBox
          Left = 8
          Top = 88
          Width = 145
          Height = 27
          Style = csDropDownList
          ItemHeight = 19
          TabOrder = 0
          OnChange = comboLowerCrossSecChange
        end
        object comboUpperCrossSec: TComboBox
          Left = 8
          Top = 32
          Width = 145
          Height = 27
          Style = csDropDownList
          ItemHeight = 19
          TabOrder = 1
          OnChange = comboUpperCrossSecChange
        end
        object comboLines: TComboBox
          Left = 8
          Top = 152
          Width = 145
          Height = 27
          Style = csDropDownList
          ItemHeight = 19
          TabOrder = 2
          OnChange = comboLinesChange
        end
        object btnLoad: TButton
          Left = 8
          Top = 232
          Width = 75
          Height = 25
          Caption = 'Load'
          TabOrder = 3
          OnClick = btnLoadClick
        end
        object btnSave: TButton
          Left = 8
          Top = 264
          Width = 75
          Height = 25
          Caption = 'Save'
          TabOrder = 4
          OnClick = btnSaveClick
        end
      end
    end
    object tabInterpolate: TTabSheet
      Caption = 'Interpolate'
      ImageIndex = 2
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 169
        Height = 434
        Align = alLeft
        TabOrder = 0
        object Label5: TLabel
          Left = 8
          Top = 64
          Width = 37
          Height = 19
          Caption = 'Delta'
        end
        object Label6: TLabel
          Left = 8
          Top = 8
          Width = 31
          Height = 19
          Caption = 'Line'
        end
        object adeDelta: TArgusDataEntry
          Left = 8
          Top = 88
          Width = 145
          Height = 22
          ItemHeight = 0
          TabOrder = 0
          Text = '0'
          OnExit = btnApplyClick
          DataType = dtReal
          Max = 1.000000000000000000
          ChangeDisabledColor = True
        end
        object comboLines2: TComboBox
          Left = 8
          Top = 32
          Width = 145
          Height = 27
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
          OnChange = comboLines2Change
        end
        object btnApply: TButton
          Left = 8
          Top = 120
          Width = 75
          Height = 25
          Caption = 'Apply'
          TabOrder = 2
          OnClick = btnApplyClick
        end
      end
      object zbMap: TRbwZoomBox
        Left = 169
        Top = 0
        Width = 390
        Height = 434
        HorzScrollBar.Range = 386
        VertScrollBar.Range = 430
        Align = alClient
        AutoScroll = False
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        OnResize = zbMapResize
        BottomMargin = 20
        LeftMargin = 20
        RightMargin = 20
        TopMargin = 20
        MinX = 20.000000000000000000
        MaxX = 366.000000000000000000
        MinY = 20.000000000000000000
        MaxY = 410.000000000000000000
        Multiplier = 1.000000000000000000
        OnPaint = zbMapPaint
        PBColor = clWindow
        PBCursor = crDefault
        PBDragCursor = crDrag
        PBDragKind = dkDrag
        PBDragMode = dmManual
        PBEnabled = True
        PBFont.Charset = ANSI_CHARSET
        PBFont.Color = clWindowText
        PBFont.Height = -17
        PBFont.Name = 'Arial'
        PBFont.Style = []
        PBHeight = 430
        PBLeft = 0
        PBShowHint = False
        PBTag = 0
        PBTop = 0
        PBVisible = True
        PBWidth = 386
        SBrush.Style = bsClear
        SCursor = crDefault
        SDragCursor = crDrag
        SelectionWidth = 3
      end
    end
  end
  object xbaseShapeFiles: TXBase
    Active = False
    AutoUpDate = True
    DebugErr = False
    Deleted = False
    Left = 296
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 256
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 216
    Top = 8
  end
end
