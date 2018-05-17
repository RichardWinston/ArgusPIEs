object frameIceSat: TframeIceSat
  Left = 0
  Top = 0
  Width = 380
  Height = 93
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 380
    Height = 93
    Align = alClient
    Caption = 'Ice saturation parameters'
    TabOrder = 0
    object JvPageListMain: TJvPageList
      Left = 2
      Top = 15
      Width = 376
      Height = 76
      ActivePage = jvsp3UDEF
      PropagateEnable = False
      Align = alClient
      object jvsp0None: TJvStandardPage
        Left = 0
        Top = 0
        Width = 376
        Height = 76
        Caption = 'jvsp0None'
      end
      object jvsp1EXPO: TJvStandardPage
        Left = 0
        Top = 0
        Width = 376
        Height = 76
        Caption = 'jvsp1EXPO'
        object lbl1SWRESI: TLabel
          Left = 8
          Top = 11
          Width = 43
          Height = 13
          Caption = 'SWRESI'
        end
        object lblW: TLabel
          Left = 48
          Top = 35
          Width = 11
          Height = 13
          Caption = 'W'
        end
        object Label1: TLabel
          Left = 144
          Top = 11
          Width = 117
          Height = 13
          Caption = 'Minimum liquid saturation'
        end
        object ade1SWRESI: TArgusDataEntry
          Left = 72
          Top = 8
          Width = 65
          Height = 22
          ItemHeight = 13
          TabOrder = 0
          Text = '0'
          DataType = dtReal
          Max = 1.000000000000000000
          ChangeDisabledColor = True
        end
        object ade1W: TArgusDataEntry
          Left = 72
          Top = 32
          Width = 65
          Height = 22
          ItemHeight = 13
          TabOrder = 1
          Text = '0'
          DataType = dtReal
          Max = 1.000000000000000000
          ChangeDisabledColor = True
        end
      end
      object jvsp2PLIN: TJvStandardPage
        Left = 0
        Top = 0
        Width = 376
        Height = 76
        Caption = 'jvsp2PLIN'
        object lbl2SWRESI: TLabel
          Left = 8
          Top = 11
          Width = 43
          Height = 13
          Caption = 'SWRESI'
        end
        object lbl2TSWRESI: TLabel
          Left = 8
          Top = 35
          Width = 50
          Height = 13
          Caption = 'TSWRESI'
        end
        object Label2: TLabel
          Left = 144
          Top = 11
          Width = 117
          Height = 13
          Caption = 'Minimum liquid saturation'
        end
        object Label3: TLabel
          Left = 144
          Top = 35
          Width = 184
          Height = 13
          Caption = 'Temperature at which SWRESI occurs'
        end
        object ade2SWRESI: TArgusDataEntry
          Left = 72
          Top = 8
          Width = 65
          Height = 22
          ItemHeight = 13
          TabOrder = 0
          Text = '0'
          DataType = dtReal
          Max = 1.000000000000000000
          ChangeDisabledColor = True
        end
        object ade2TSWRESI: TArgusDataEntry
          Left = 72
          Top = 32
          Width = 65
          Height = 22
          ItemHeight = 13
          TabOrder = 1
          Text = '0'
          DataType = dtReal
          Max = 1.000000000000000000
          ChangeDisabledColor = True
        end
      end
      object jvsp3UDEF: TJvStandardPage
        Left = 0
        Top = 0
        Width = 376
        Height = 76
        Caption = 'jvsp3UDEF'
        DesignSize = (
          376
          76)
        object lbl3NSIPAR: TLabel
          Left = 8
          Top = 35
          Width = 40
          Height = 13
          Caption = 'NSIPAR'
        end
        object Label4: TLabel
          Left = 8
          Top = 8
          Width = 165
          Height = 13
          Caption = 'Number of user-defined parameters'
        end
        object ade3NSIPAR: TArgusDataEntry
          Left = 72
          Top = 32
          Width = 65
          Height = 22
          ItemHeight = 13
          TabOrder = 0
          Text = '0'
          OnExit = ade3NSIPARExit
          DataType = dtInteger
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object rdg3SIPAR: TRbwDataGrid4
          Left = 216
          Top = 8
          Width = 149
          Height = 49
          Anchors = [akLeft, akTop, akRight]
          ColCount = 1
          FixedCols = 0
          RowCount = 1
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
          TabOrder = 1
          AutoDistributeText = False
          AutoIncreaseColCount = False
          AutoIncreaseRowCount = False
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
              Format = rcf4Real
              LimitToList = False
              MaxLength = 0
              ParentButtonFont = False
              WordWrapCaptions = False
              WordWrapCells = False
              AutoAdjustColWidths = False
            end>
        end
      end
    end
  end
end
