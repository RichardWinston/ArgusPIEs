object frmTimeSeries: TfrmTimeSeries
  Left = 339
  Top = 259
  Caption = 'Time Series Plots'
  ClientHeight = 435
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 394
    Width = 625
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 412
    ExplicitWidth = 635
    object BitBtn1: TBitBtn
      Left = 544
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkClose
    end
    object btnPrint: TButton
      Left = 304
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Print Chart'
      TabOrder = 1
      OnClick = btnPrintClick
    end
    object btnSave: TButton
      Left = 384
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 2
      OnClick = btnSaveClick
    end
    object btnHelp: TBitBtn
      Left = 464
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 3
      OnClick = btnHelpClick
      Kind = bkHelp
    end
    object btnPrintSetup: TButton
      Left = 224
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Printer Setup'
      TabOrder = 4
      OnClick = btnPrintSetupClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 625
    Height = 394
    ActivePage = tabSeries
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    ExplicitWidth = 635
    ExplicitHeight = 412
    object tabSeries: TTabSheet
      Caption = 'Series'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter1: TSplitter
        Left = 0
        Top = 103
        Width = 627
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 627
        Height = 103
        Align = alClient
        TabOrder = 0
        object rgDataTypes: TRadioGroup
          Left = 0
          Top = 0
          Width = 623
          Height = 81
          Align = alTop
          Caption = 'Type of data to plot'
          TabOrder = 0
          OnClick = rgDataTypesClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 106
        Width = 627
        Height = 277
        Align = alBottom
        TabOrder = 1
        object Panel3: TPanel
          Left = 1
          Top = 1
          Width = 625
          Height = 24
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            Left = 8
            Top = 4
            Width = 123
            Height = 14
            Caption = 'Observation points to plot'
          end
        end
        object clbDataSets: TCheckListBox
          Left = 1
          Top = 25
          Width = 625
          Height = 251
          Align = alClient
          ItemHeight = 14
          TabOrder = 1
        end
      end
    end
    object tabPlots: TTabSheet
      Caption = 'Plots'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Chart1: TChart
        Left = 0
        Top = 0
        Width = 627
        Height = 383
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clBlack
        Title.Font.Height = -13
        Title.Font.Name = 'Arial'
        Title.Font.Style = []
        Title.Text.Strings = (
          'HST3D Time Series Plots')
        BottomAxis.Title.Caption = 'Time'
        LeftAxis.ExactDateTime = False
        LeftAxis.LabelsOnAxis = False
        Legend.LegendStyle = lsSeries
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        PopupMenu = PopupMenu1
        TabOrder = 0
        object Series1: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clRed
          Title = 'ASerids'
          Pointer.Brush.Color = clRed
          Pointer.HorizSize = 6
          Pointer.InflateMargins = True
          Pointer.Style = psCircle
          Pointer.VertSize = 6
          Pointer.Visible = True
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
    object tabFormat: TTabSheet
      Caption = 'Format Plot'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dgSeriesNames: TDataGrid
        Left = 0
        Top = 241
        Width = 617
        Height = 124
        Align = alClient
        DefaultColWidth = 25
        DefaultRowHeight = 20
        DefaultDrawing = False
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
        TabOrder = 1
        OnDrawCell = dgSeriesNamesDrawCell
        Columns = <
          item
            Title.Caption = 'Series'
            Title.WordWrap = False
          end
          item
            ButtonStyle = cbsEllipsis
            Title.Caption = 'Color'
            Title.WordWrap = False
          end
          item
            LimitToList = True
            PickList.Strings = (
              'Rectangle'
              'Circle'
              'Triangle'
              'DownTriangle'
              'Cross'
              'Diagonal Cross'
              'Star'
              'Diamond'
              'Small Dot')
            Title.Caption = 'Symbol'
            Title.WordWrap = False
          end
          item
            Format = cfNumber
            Title.Caption = 'Vert. Size'
            Title.WordWrap = False
          end
          item
            Format = cfNumber
            Title.Caption = 'Horiz. Size'
            Title.WordWrap = False
          end>
        RowCountMin = 0
        OnEditButtonClick = dgSeriesNamesEditButtonClick
        OnUserChanged = dgSeriesNamesUserChanged
        SelectedIndex = 0
        Version = '2.0'
        ExplicitWidth = 627
        ExplicitHeight = 142
        ColWidths = (
          359
          34
          80
          56
          67)
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 617
        Height = 241
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 627
        object Label2: TLabel
          Left = 8
          Top = 16
          Width = 48
          Height = 14
          Caption = 'Chart Title'
        end
        object Label7: TLabel
          Left = 360
          Top = 8
          Width = 41
          Height = 14
          Caption = 'Left Title'
        end
        object Label6: TLabel
          Left = 488
          Top = 8
          Width = 55
          Height = 14
          Caption = 'Bottom Title'
        end
        object LeftMargin: TLabel
          Left = 360
          Top = 120
          Width = 120
          Height = 14
          Caption = 'Left Page Margin (pixels)'
        end
        object Label9: TLabel
          Left = 488
          Top = 120
          Width = 125
          Height = 14
          Caption = 'Right Page Margin (pixels)'
        end
        object Label3: TLabel
          Left = 8
          Top = 136
          Width = 121
          Height = 14
          Caption = 'Horizontal Grid Line Style'
        end
        object Label4: TLabel
          Left = 184
          Top = 136
          Width = 109
          Height = 14
          Caption = 'Vertical Grid Line Style'
        end
        object Label5: TLabel
          Left = 8
          Top = 216
          Width = 87
          Height = 14
          Caption = 'Series Information'
        end
        object Label11: TLabel
          Left = 488
          Top = 168
          Width = 134
          Height = 14
          Caption = 'Bottom Page Margin (pixels)'
        end
        object Label10: TLabel
          Left = 360
          Top = 168
          Width = 118
          Height = 14
          Caption = 'Top Page Margin (pixels)'
        end
        object Label8: TLabel
          Left = 184
          Top = 192
          Width = 76
          Height = 14
          Caption = 'Legend Position'
        end
        object btnTitleFont: TButton
          Left = 96
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Title Font'
          TabOrder = 0
          OnClick = btnTitleFontClick
        end
        object btnLegendFont: TButton
          Left = 184
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Legend Font'
          TabOrder = 1
          OnClick = btnFontClick
        end
        object edLeftTitle: TEdit
          Left = 360
          Top = 24
          Width = 121
          Height = 22
          TabOrder = 2
          Text = 'edLeftTitle'
          OnChange = edChange
        end
        object edBotTitle: TEdit
          Left = 488
          Top = 24
          Width = 121
          Height = 22
          TabOrder = 3
          Text = 'edBotTitle'
          OnChange = edChange
        end
        object memoTitle: TMemo
          Left = 8
          Top = 40
          Width = 345
          Height = 89
          TabOrder = 4
          WordWrap = False
        end
        object btnLeftTitleFont: TButton
          Left = 360
          Top = 56
          Width = 121
          Height = 25
          Caption = 'Left Title Font'
          TabOrder = 5
          OnClick = btnLeftTitleFontClick
        end
        object btnBotTitleFont: TButton
          Left = 488
          Top = 56
          Width = 121
          Height = 25
          Caption = 'Bottom Title Font'
          TabOrder = 6
          OnClick = btnBotTitleFontClick
        end
        object btnLeftAxisFont: TButton
          Left = 360
          Top = 88
          Width = 121
          Height = 25
          Caption = 'Left Axis Font'
          TabOrder = 7
          OnClick = btnFontClick
        end
        object btnBottomAxisFont: TButton
          Left = 488
          Top = 88
          Width = 121
          Height = 25
          Caption = 'Bottom Axis Font'
          TabOrder = 8
          OnClick = btnFontClick
        end
        object adeLeftMargin: TArgusDataEntry
          Left = 360
          Top = 136
          Width = 121
          Height = 22
          ItemHeight = 0
          TabOrder = 9
          Text = '0'
          OnChange = edChange
          DataType = dtInteger
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object adeRightMargin: TArgusDataEntry
          Left = 488
          Top = 136
          Width = 121
          Height = 22
          ItemHeight = 0
          TabOrder = 10
          Text = '0'
          OnChange = edChange
          DataType = dtInteger
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object comboBottomGridStyle: TComboBox
          Left = 184
          Top = 152
          Width = 145
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 12
          OnChange = comboStyleChange
          Items.Strings = (
            'clear'
            'dash'
            'dash dot'
            'dash dot dot'
            'dot'
            'inside frame'
            'solid')
        end
        object comboLeftGridStyle: TComboBox
          Left = 8
          Top = 152
          Width = 145
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 11
          OnChange = comboStyleChange
          Items.Strings = (
            'clear'
            'dash'
            'dash dot'
            'dash dot dot'
            'dot'
            'inside frame'
            'solid')
        end
        object cbLegend: TCheckBox
          Left = 8
          Top = 184
          Width = 97
          Height = 17
          Caption = 'Show Legend'
          TabOrder = 13
          OnClick = edChange
        end
        object adeTopMargin: TArgusDataEntry
          Left = 360
          Top = 184
          Width = 121
          Height = 22
          ItemHeight = 0
          TabOrder = 14
          Text = '0'
          OnChange = edChange
          DataType = dtInteger
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object adeBottomMargin: TArgusDataEntry
          Left = 488
          Top = 184
          Width = 121
          Height = 22
          ItemHeight = 0
          TabOrder = 15
          Text = '0'
          OnChange = edChange
          DataType = dtInteger
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object comboLegendPosition: TComboBox
          Left = 184
          Top = 208
          Width = 145
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 16
          OnChange = edChange
          Items.Strings = (
            'Right'
            'Bottom'
            'Left'
            'Top')
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Left = 8
    Top = 418
  end
  object PrintDialog1: TPrintDialog
    Left = 40
    Top = 418
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 72
    Top = 418
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 104
    Top = 416
  end
  object ColorDialog1: TColorDialog
    Left = 136
    Top = 416
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 416
    object Clipboard1: TMenuItem
      Caption = 'Clipboard'
      GroupIndex = 1
      object EnhancedWindowsMetafile1: TMenuItem
        Caption = 'Enhanced Windows Metafile'
        GroupIndex = 1
        OnClick = EnhancedWindowsMetafile1Click
      end
      object WindowsMetafile1: TMenuItem
        Caption = 'Windows Metafile'
        GroupIndex = 1
        OnClick = WindowsMetafile1Click
      end
      object Bitmap1: TMenuItem
        Caption = 'Bitmap'
        GroupIndex = 1
        OnClick = Bitmap1Click
      end
      object DataasText1: TMenuItem
        Caption = 'Data as Text'
        GroupIndex = 1
        OnClick = DataasText1Click
      end
    end
    object File1: TMenuItem
      Caption = 'File'
      GroupIndex = 1
      object EnhancedWindowsMetafile2: TMenuItem
        Caption = 'Enhanced Windows Metafile'
        OnClick = EnhancedWindowsMetafile2Click
      end
      object WindowsMetafile2: TMenuItem
        Caption = 'Windows Metafile'
        OnClick = WindowsMetafile2Click
      end
      object Bitmap2: TMenuItem
        Caption = 'Bitmap'
        OnClick = Bitmap2Click
      end
      object DataasText2: TMenuItem
        Caption = 'Data as Text'
        OnClick = btnSaveClick
      end
    end
  end
end
