object frmNodeNumConvert: TfrmNodeNumConvert
  Left = 289
  Top = 115
  Caption = 'Convert Node Numbers'
  ClientHeight = 242
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 274
    Height = 193
    ActivePage = tabSutraToArgus
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object tabArgusToSutra: TTabSheet
      Caption = 'Argus Nodes to SUTRA Nodes'
      object sgSutraNodes: TStringGrid
        Left = 0
        Top = 41
        Width = 266
        Height = 94
        Align = alClient
        ColCount = 3
        DefaultColWidth = 80
        FixedCols = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 0
        RowHeights = (
          24
          24
          24
          24
          24)
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 266
        Height = 41
        Align = alTop
        TabOrder = 1
        object lblArgusNodeNumber: TLabel
          Left = 96
          Top = 13
          Width = 100
          Height = 19
          Caption = 'Node Number'
        end
        object adeArgusNodeNumber: TArgusDataEntry
          Left = 8
          Top = 8
          Width = 81
          Height = 22
          ItemHeight = 19
          TabOrder = 0
          Text = '0'
          OnChange = adeArgusNodeNumberChange
          DataType = dtInteger
          Max = 1.000000000000000000
          ChangeDisabledColor = True
        end
      end
    end
    object tabSutraToArgus: TTabSheet
      Caption = 'SUTRA Nodes to Argus Nodes'
      ImageIndex = 1
      object lblSutraNodeNumber: TLabel
        Left = 104
        Top = 13
        Width = 162
        Height = 19
        Caption = 'SUTRA Node Number '
      end
      object lblArgusNodeNumberResult: TLabel
        Left = 104
        Top = 45
        Width = 148
        Height = 19
        Caption = 'Argus Node Number'
      end
      object Label1: TLabel
        Left = 104
        Top = 77
        Width = 138
        Height = 19
        Caption = 'Argus Unit Number'
      end
      object Label2: TLabel
        Left = 104
        Top = 109
        Width = 104
        Height = 19
        Caption = 'Layer Number'
      end
      object adeSutraNodeNumber: TArgusDataEntry
        Left = 8
        Top = 8
        Width = 89
        Height = 22
        ItemHeight = 19
        TabOrder = 0
        Text = '0'
        OnChange = adeSutraNodeNumberChange
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeArgusNodeNumberResult: TArgusDataEntry
        Left = 8
        Top = 40
        Width = 89
        Height = 22
        ItemHeight = 19
        TabOrder = 1
        Text = '0'
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeUnitNumber: TArgusDataEntry
        Left = 8
        Top = 72
        Width = 89
        Height = 22
        ItemHeight = 19
        TabOrder = 2
        Text = '0'
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeLayerNumber: TArgusDataEntry
        Left = 8
        Top = 104
        Width = 89
        Height = 22
        ItemHeight = 19
        TabOrder = 3
        Text = '0'
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 193
    Width = 274
    Height = 49
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 200
      Top = 8
      Width = 75
      Height = 33
      TabOrder = 0
      Kind = bkClose
    end
    object rgConversionType: TRadioGroup
      Left = 8
      Top = 0
      Width = 185
      Height = 41
      Caption = 'Conversion type'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Nodes'
        'Elements')
      TabOrder = 1
      OnClick = rgConversionTypeClick
    end
  end
end
