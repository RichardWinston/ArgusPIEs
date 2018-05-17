object frmMPathPlot: TfrmMPathPlot
  Left = 392
  Top = 197
  HelpContext = 10180
  Caption = 'Plot MODPATH Results'
  ClientHeight = 415
  ClientWidth = 653
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object pnlBottom: TPanel
    Left = 0
    Top = 345
    Width = 653
    Height = 70
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      653
      70)
    object btnRead: TButton
      Left = 320
      Top = 40
      Width = 77
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Read Data'
      TabOrder = 2
      OnClick = btnReadClick
    end
    object btnMPathHelp: TBitBtn
      Left = 404
      Top = 40
      Width = 77
      Height = 25
      HelpContext = 10180
      Anchors = [akTop, akRight]
      Caption = 'Help'
      TabOrder = 3
      Kind = bkHelp
    end
    object btnMPathCancel: TBitBtn
      Left = 488
      Top = 40
      Width = 78
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 4
      Kind = bkCancel
    end
    object btnMPathOK: TBitBtn
      Left = 573
      Top = 40
      Width = 76
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 5
      Kind = bkOK
    end
    object rgDataType: TRadioGroup
      Left = 0
      Top = 0
      Width = 145
      Height = 70
      Align = alLeft
      Caption = 'Data type'
      ItemIndex = 0
      Items.Strings = (
        'Pathlines'
        'Endpoints'
        'Time Series')
      TabOrder = 0
      OnClick = rgDataTypeClick
    end
    object rgPlotLocation: TRadioGroup
      Left = 145
      Top = 0
      Width = 152
      Height = 70
      Align = alLeft
      Caption = 'Plot Location'
      Enabled = False
      ItemIndex = 1
      Items.Strings = (
        'Starting location'
        'Ending location')
      TabOrder = 1
    end
  end
  object PageContModpath: TPageControl
    Left = 0
    Top = 0
    Width = 653
    Height = 345
    ActivePage = tabPreview
    Align = alClient
    TabOrder = 0
    OnChange = PageContModpathChange
    object tabPreview: TTabSheet
      Caption = 'Preview'
      object PaintBox1: TPaintBox
        Left = 0
        Top = 0
        Width = 645
        Height = 311
        Align = alClient
        OnPaint = PaintBox1Paint
      end
    end
    object TabEndPoints: TTabSheet
      Caption = 'Endpoint summary'
      ImageIndex = 1
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DataGrid1: TDataGrid
        Left = 0
        Top = 0
        Width = 645
        Height = 270
        Align = alClient
        ColCount = 13
        DefaultRowHeight = 20
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
        TabOrder = 0
        Columns = <
          item
            Title.Caption = 'Zone'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Number of particles'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Percent of particles'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Maximum travel time'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Minimum travel time'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Mean travel time'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Median travel time'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Std. dev. travel times'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Mean distance traveled'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Mean velocity'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Maximum velocity'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Minimum velocity'
            Title.WordWrap = False
          end
          item
            Title.Caption = 'Std. dev. velocity'
            Title.WordWrap = False
          end>
        RowCountMin = 0
        SelectedIndex = 0
        Version = '2.0'
        ColWidths = (
          32
          102
          100
          112
          110
          88
          97
          109
          126
          80
          98
          96
          91)
      end
      object pnlEndPoint: TPanel
        Left = 0
        Top = 270
        Width = 645
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object rgEndpointSummary: TRadioGroup
          Left = 0
          Top = 0
          Width = 185
          Height = 41
          Align = alLeft
          Caption = 'Summarize endpoints by'
          Columns = 2
          ItemIndex = 1
          Items.Strings = (
            'Starting Zone'
            'Ending Zone')
          TabOrder = 0
          OnClick = rgEndpointSummaryClick
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Pathlines (*.lin)|*.lin|All Files (*.*)|*.*'
    Left = 264
    Top = 376
  end
end
