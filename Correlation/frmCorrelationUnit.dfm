object frmCorrelation: TfrmCorrelation
  Left = 352
  Top = 276
  Width = 385
  Height = 388
  Caption = 'Correlation'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 20
  object Panel1: TPanel
    Left = 0
    Top = 251
    Width = 377
    Height = 110
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 39
      Height = 20
      Caption = 'Layer'
    end
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 89
      Height = 20
      Caption = 'X Parameter'
    end
    object Label3: TLabel
      Left = 8
      Top = 74
      Width = 89
      Height = 20
      Caption = 'Y Parameter'
    end
    object BitBtn1: TBitBtn
      Left = 265
      Top = 70
      Width = 104
      Height = 28
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkClose
    end
    object comboNames: TsiComboBox
      Left = 104
      Top = 10
      Width = 145
      Height = 28
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 20
      TabOrder = 1
      OnChange = comboNamesChange
    end
    object comboX: TsiComboBox
      Left = 104
      Top = 40
      Width = 145
      Height = 28
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      ItemHeight = 20
      TabOrder = 2
      OnChange = comboXChange
    end
    object ComboY: TsiComboBox
      Left = 104
      Top = 70
      Width = 145
      Height = 28
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      ItemHeight = 20
      TabOrder = 3
      OnChange = comboXChange
    end
    object btnPlot: TButton
      Left = 264
      Top = 10
      Width = 105
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Plot'
      Enabled = False
      TabOrder = 4
      OnClick = btnPlotClick
    end
    object btnCopyValues: TButton
      Left = 264
      Top = 40
      Width = 105
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Copy Values'
      Enabled = False
      TabOrder = 5
      OnClick = btnCopyValuesClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 377
    Height = 251
    ActivePage = tabChart
    Align = alClient
    TabOrder = 1
    object tabChart: TTabSheet
      Caption = 'Chart'
      object chartData: TChart
        Left = 0
        Top = 0
        Width = 369
        Height = 216
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Text.Strings = (
          '')
        BottomAxis.LabelsFont.Charset = DEFAULT_CHARSET
        BottomAxis.LabelsFont.Color = clBlack
        BottomAxis.LabelsFont.Height = -13
        BottomAxis.LabelsFont.Name = 'Arial'
        BottomAxis.LabelsFont.Style = []
        BottomAxis.Title.Font.Charset = DEFAULT_CHARSET
        BottomAxis.Title.Font.Color = clBlack
        BottomAxis.Title.Font.Height = -16
        BottomAxis.Title.Font.Name = 'Arial'
        BottomAxis.Title.Font.Style = []
        LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
        LeftAxis.LabelsFont.Color = clBlack
        LeftAxis.LabelsFont.Height = -13
        LeftAxis.LabelsFont.Name = 'Arial'
        LeftAxis.LabelsFont.Style = []
        LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
        LeftAxis.Title.Font.Color = clBlack
        LeftAxis.Title.Font.Height = -16
        LeftAxis.Title.Font.Name = 'Arial'
        LeftAxis.Title.Font.Style = []
        Legend.Font.Charset = DEFAULT_CHARSET
        Legend.Font.Color = clBlack
        Legend.Font.Height = -13
        Legend.Font.Name = 'Arial'
        Legend.Font.Style = []
        Legend.Visible = False
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Values: TPointSeries
          Marks.ArrowLength = 0
          Marks.Visible = False
          SeriesColor = clRed
          Title = 'Values'
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = True
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1
          YValues.Order = loNone
        end
      end
    end
    object tabValues: TTabSheet
      Caption = 'Values'
      ImageIndex = 1
      object sgValues: TStringGrid
        Left = 0
        Top = 0
        Width = 369
        Height = 216
        Align = alClient
        ColCount = 3
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ColWidths = (
          64
          119
          132)
      end
    end
  end
end
