object frmCellFlows: TfrmCellFlows
  Left = 348
  Top = 112
  Width = 574
  Height = 544
  Caption = 'Flow Rates vs. Time'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Times New Roman'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 19
  object Splitter1: TSplitter
    Left = 0
    Top = 161
    Width = 566
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 415
    Width = 566
    Height = 73
    Align = alBottom
    TabOrder = 0
    object lblCounts: TLabel
      Left = 184
      Top = 43
      Width = 183
      Height = 19
      Caption = 'Colums: 0, Rows: 0, Layers: 0'
    end
    object Label1: TLabel
      Left = 184
      Top = 11
      Width = 74
      Height = 19
      Caption = 'Cells to Plot'
    end
    object btnSelectFile: TButton
      Left = 7
      Top = 7
      Width = 122
      Height = 26
      Caption = 'Select Budget File'
      TabOrder = 0
      OnClick = btnSelectFileClick
    end
    object BitBtn1: TBitBtn
      Left = 497
      Top = 39
      Width = 64
      Height = 26
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkClose
    end
    object btnUpdatePlot: TButton
      Left = 7
      Top = 40
      Width = 122
      Height = 25
      Caption = 'Update Plot'
      Enabled = False
      TabOrder = 2
      OnClick = btnUpdatePlotClick
    end
    object seCells: TSpinEdit
      Left = 139
      Top = 6
      Width = 40
      Height = 29
      Enabled = False
      MaxValue = 1000000
      MinValue = 1
      TabOrder = 3
      Value = 1
      OnChange = seCellsChange
    end
    object comboModelChoice: TComboBox
      Left = 272
      Top = 8
      Width = 289
      Height = 27
      Style = csDropDownList
      ItemHeight = 19
      TabOrder = 4
      Items.Strings = (
        'MODFLOW-96'
        'MODFLOW-2000 (Version 1.2 or later)')
    end
  end
  object chartFlow: TChart
    Left = 0
    Top = 164
    Width = 566
    Height = 251
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = clBlue
    Title.Font.Height = -19
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = []
    Title.Text.Strings = (
      'Flow Rates')
    BottomAxis.Title.Caption = 'Time or Stored Time Step'
    BottomAxis.Title.Font.Charset = ANSI_CHARSET
    BottomAxis.Title.Font.Color = clBlack
    BottomAxis.Title.Font.Height = -16
    BottomAxis.Title.Font.Name = 'Times New Roman'
    BottomAxis.Title.Font.Style = []
    LeftAxis.Title.Caption = 'Flow Rate'
    LeftAxis.Title.Font.Charset = ANSI_CHARSET
    LeftAxis.Title.Font.Color = clBlack
    LeftAxis.Title.Font.Height = -16
    LeftAxis.Title.Font.Name = 'Times New Roman'
    LeftAxis.Title.Font.Style = []
    View3D = False
    Align = alClient
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 566
    Height = 161
    Align = alTop
    TabOrder = 2
    object Splitter2: TSplitter
      Left = 293
      Top = 1
      Width = 3
      Height = 159
      Cursor = crHSplit
      Align = alRight
    end
    object clbDataSets: TCheckListBox
      Left = 1
      Top = 1
      Width = 292
      Height = 159
      Align = alClient
      ItemHeight = 19
      TabOrder = 0
    end
    object dgCells: TRbwDataGrid
      Left = 296
      Top = 1
      Width = 269
      Height = 159
      Align = alRight
      ColCount = 4
      Enabled = False
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 1
      ColorSelectedRow = True
      Columns = <
        item
          CheckMax = False
          CheckMin = True
          CheckedString = 'Yes'
          Format = rcfInteger
          LimitToList = False
          MaxLength = 0
          Max = 1
          Min = 1
          UnCheckedString = 'No'
        end
        item
          CheckMax = True
          CheckMin = True
          CheckedString = 'Yes'
          Format = rcfInteger
          LimitToList = False
          MaxLength = 0
          Max = 1
          Min = 1
          UnCheckedString = 'No'
        end
        item
          CheckMax = True
          CheckMin = True
          CheckedString = 'Yes'
          Format = rcfInteger
          LimitToList = False
          MaxLength = 0
          Max = 1
          Min = 1
          UnCheckedString = 'No'
        end
        item
          CheckMax = False
          CheckMin = False
          CheckedString = 'Yes'
          Format = rcfBoolean
          LimitToList = False
          MaxLength = 0
          UnCheckedString = 'No'
        end>
      SelectedRowColor = clAqua
      WordWrapColTitles = False
      UnselectableColor = clBtnFace
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.bud|*.bud|*.*|*.*'
    Left = 32
    Top = 16
  end
  object ChartEditor1: TChartEditor
    Chart = chartFlow
    HideTabs = []
    Left = 64
    Top = 20
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 236
    object File1: TMenuItem
      Caption = '&File'
      object SelectBudgetFile1: TMenuItem
        Caption = '&Select Budget File'
        OnClick = btnSelectFileClick
      end
      object UpdatePlot1: TMenuItem
        Caption = '&Update Plot'
        OnClick = btnUpdatePlotClick
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object FormatChart1: TMenuItem
      Caption = '&Format Chart'
      OnClick = FormatChart1Click
    end
  end
end
