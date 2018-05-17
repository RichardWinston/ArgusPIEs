object Form: TForm
  Left = 192
  Top = 107
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 16
    Width = 95
    Height = 13
    Caption = 'Number of data sets'
  end
  object Label2: TLabel
    Left = 376
    Top = 16
    Width = 74
    Height = 13
    Caption = 'Number of rows'
  end
  object Label3: TLabel
    Left = 544
    Top = 16
    Width = 91
    Height = 13
    Caption = 'Number of columns'
  end
  object dg3dData: TRBWDataGrid3d
    Left = 328
    Top = 120
    Width = 289
    Height = 193
    TabOrder = 0
    GridColCount = 5
    FixedCol = 0
    FixedRow = 0
    GridRowcount = 5
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect]
  end
  object seDataSets: TSpinEdit
    Left = 8
    Top = 8
    Width = 65
    Height = 22
    MaxValue = 2147483647
    MinValue = 1
    TabOrder = 1
    Value = 1
    OnChange = seDataSetsChange
  end
  object sgNames: TStringGrid
    Left = 8
    Top = 64
    Width = 209
    Height = 513
    ColCount = 1
    DefaultColWidth = 200
    FixedCols = 0
    RowCount = 2
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 200
    Top = 16
    Width = 97
    Height = 17
    Caption = 'Use existing grid'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object seRows: TSpinEdit
    Left = 304
    Top = 8
    Width = 65
    Height = 22
    MaxValue = 2147483647
    MinValue = 1
    TabOrder = 4
    Value = 1
  end
  object seColumns: TSpinEdit
    Left = 472
    Top = 8
    Width = 65
    Height = 22
    MaxValue = 2147483647
    MinValue = 1
    TabOrder = 5
    Value = 1
  end
  object DataGrid1: TDataGrid
    Left = 376
    Top = 432
    Width = 320
    Height = 120
    DefaultRowHeight = 20
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
    TabOrder = 6
    Columns = <
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    RowCountMin = 0
    SelectedIndex = 1
    Version = '2.0'
  end
  object edGridLayerName: TEdit
    Left = 8
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'MODFLOW FD Grid'
  end
end
