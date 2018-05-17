inherited frmContourImporter: TfrmContourImporter
  Left = 496
  Top = 307
  Width = 761
  Height = 386
  HelpContext = 1610
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Import MODFLOW Contours from Spreadsheet'
  Font.Height = -16
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 318
    Width = 753
    Height = 34
    Align = alBottom
    TabOrder = 0
    object lblContourCount: TLabel
      Left = 80
      Top = 7
      Width = 122
      Height = 19
      Caption = 'Number of contours'
      Visible = False
    end
    object lblContourSelect: TLabel
      Left = 320
      Top = 7
      Width = 87
      Height = 19
      Caption = 'Select contour'
      Visible = False
    end
    object btnCancel: TBitBtn
      Left = 533
      Top = 5
      Width = 66
      Height = 24
      Hint = 'Quit without importing anything'
      Anchors = [akTop, akRight]
      Caption = '&Quit'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Kind = bkCancel
    end
    object btnBack: TBitBtn
      Left = 605
      Top = 5
      Width = 66
      Height = 24
      Hint = 'Go back to the previous step'
      Anchors = [akTop, akRight]
      Caption = '&Back'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
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
    object btnNext: TBitBtn
      Left = 675
      Top = 5
      Width = 66
      Height = 24
      Hint = 'Go to the next step or finish'
      Anchors = [akTop, akRight]
      Caption = '&Next'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
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
    object seContourCount: TSpinEdit
      Left = 13
      Top = 2
      Width = 60
      Height = 29
      Hint = 'Specify the number of contours that you wish to import'
      MaxValue = 0
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Value = 0
      Visible = False
      OnChange = seContourCountChange
    end
    object seContourSelect: TSpinEdit
      Left = 253
      Top = 2
      Width = 60
      Height = 29
      Hint = 'Specify which contour you wish to edit'
      MaxValue = 1
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Value = 1
      Visible = False
      OnChange = seContourSelectChange
    end
    object BitBtn1: TBitBtn
      Left = 457
      Top = 5
      Width = 67
      Height = 24
      Hint = 'Show help for this dialog box'
      HelpContext = 1610
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Kind = bkHelp
    end
  end
  object pcWizard: TPageControl
    Left = 0
    Top = 0
    Width = 753
    Height = 318
    ActivePage = tabSelectLayers
    Align = alClient
    TabOrder = 1
    object tabSelectLayers: TTabSheet
      Caption = 'tabSelectLayers'
      TabVisible = False
      object Label1: TLabel
        Left = 8
        Top = 17
        Width = 38
        Height = 19
        Caption = 'Layer:'
      end
      object Label2: TLabel
        Left = 8
        Top = 84
        Width = 640
        Height = 19
        Caption = 
          'Use this dialog box to import contours from a spreadsheet when t' +
          'here are numerous "indexed" parameters.'
        WordWrap = True
      end
      object Label4: TLabel
        Left = 8
        Top = 143
        Width = 373
        Height = 38
        Caption = 
          'You can use Ctrl-V to paste into any of the tables on the next p' +
          'age.'
        WordWrap = True
      end
      object comboLayer: TComboBox
        Left = 8
        Top = 42
        Width = 721
        Height = 27
        Hint = 'Select the layer into which you wish to import data'
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 19
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = comboLayerChange
      end
    end
    object tabLayerParameters: TTabSheet
      Caption = 'tabLayerParameters'
      ImageIndex = 1
      TabVisible = False
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 195
        Height = 315
        Align = alLeft
        TabOrder = 0
        object dg3dCoordinates: TRBWDataGrid3d
          Left = 1
          Top = 26
          Width = 193
          Height = 245
          Align = alClient
          TabOrder = 0
          OnChange = dg3dCoordinatesChange
          DefaultColWidth = 64
          DefaultRowHeight = 24
          FixedCol = 0
          FixedRow = 1
          GridColCount = 2
          GridRowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs]
        end
        object Panel4: TPanel
          Left = 1
          Top = 271
          Width = 193
          Height = 43
          Align = alBottom
          TabOrder = 1
          object Label3: TLabel
            Left = 76
            Top = 14
            Width = 106
            Height = 19
            Caption = 'Number of nodes'
          end
          object sePointCount: TSpinEdit
            Left = 8
            Top = 8
            Width = 60
            Height = 29
            MaxValue = 1000000
            MinValue = 1
            TabOrder = 0
            Value = 1
            OnChange = sePointCountChange
          end
        end
        object Panel5: TPanel
          Left = 1
          Top = 1
          Width = 193
          Height = 25
          Align = alTop
          Caption = 'Coordinates'
          TabOrder = 2
        end
      end
      object Panel2: TPanel
        Left = 195
        Top = 0
        Width = 550
        Height = 315
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 1
        object Splitter1: TSplitter
          Left = 1
          Top = 85
          Width = 548
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        object Splitter2: TSplitter
          Left = 196
          Top = 88
          Width = 3
          Height = 226
          Cursor = crHSplit
        end
        object sg3dTimeParameters: TRBWDataGrid3d
          Left = 1
          Top = 88
          Width = 195
          Height = 226
          Align = alLeft
          TabOrder = 0
          DefaultColWidth = 64
          DefaultRowHeight = 24
          FixedCol = 1
          FixedRow = 1
          GridColCount = 2
          GridRowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs]
          OnSelectCell = sg3dUnindexedParametersSelectCell
          OnSetEditText = sg3dUnindexedParametersSetEditText
        end
        object dg3dParmGroup1: TRBWDataGrid3d
          Left = 199
          Top = 88
          Width = 350
          Height = 226
          Align = alClient
          TabOrder = 1
          Visible = False
          DefaultColWidth = 64
          DefaultRowHeight = 24
          FixedCol = 1
          FixedRow = 1
          GridColCount = 2
          GridRowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs]
          OnSelectCell = sg3dUnindexedParametersSelectCell
          OnSetEditText = sg3dUnindexedParametersSetEditText
        end
        object sg3dUnindexedParameters: TRBWDataGrid3d
          Left = 1
          Top = 1
          Width = 548
          Height = 84
          Align = alTop
          TabOrder = 2
          DefaultColWidth = 64
          DefaultRowHeight = 24
          FixedCol = 1
          FixedRow = 1
          GridColCount = 2
          GridRowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs]
          OnSelectCell = sg3dUnindexedParametersSelectCell
          OnSetEditText = sg3dUnindexedParametersSetEditText
        end
      end
    end
  end
end
