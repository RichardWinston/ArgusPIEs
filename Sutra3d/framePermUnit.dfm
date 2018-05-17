object framePerm: TframePerm
  Left = 0
  Top = 0
  Width = 386
  Height = 90
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 386
    Height = 90
    Align = alClient
    BiDiMode = bdLeftToRight
    Caption = 'Permeability parameters'
    ParentBiDiMode = False
    TabOrder = 0
    object JvPageListMain: TJvPageList
      Left = 2
      Top = 15
      Width = 382
      Height = 73
      ActivePage = jvsp5UDEF
      PropagateEnable = False
      Align = alClient
      object jvsp0None: TJvStandardPage
        Left = 0
        Top = 0
        Width = 382
        Height = 73
        Caption = 'jvsp0None'
      end
      object jvsp1VGEN: TJvStandardPage
        Left = 0
        Top = 0
        Width = 382
        Height = 73
        Caption = 'jvsp1VGEN'
        object lbl1SWRES: TLabel
          Left = 16
          Top = 11
          Width = 40
          Height = 13
          Caption = 'SWRES'
        end
        object lblVN: TLabel
          Left = 48
          Top = 35
          Width = 15
          Height = 13
          Caption = 'VN'
        end
        object Label1: TLabel
          Left = 144
          Top = 11
          Width = 162
          Height = 13
          Caption = 'Residual water saturation for Rel k'
        end
        object ade1SWRES: TArgusDataEntry
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
        object ade1VN: TArgusDataEntry
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
      object jvsp2BCOR: TJvStandardPage
        Left = 0
        Top = 0
        Width = 382
        Height = 73
        Caption = 'jvsp2BCOR'
        object lbl2PENT: TLabel
          Left = 32
          Top = 11
          Width = 29
          Height = 13
          Caption = 'PENT'
        end
        object lbl2RLAMB: TLabel
          Left = 24
          Top = 35
          Width = 37
          Height = 13
          Caption = 'RLAMB'
        end
        object Label2: TLabel
          Left = 144
          Top = 11
          Width = 81
          Height = 13
          Caption = 'Air entry pressure'
        end
        object ade2PENT: TArgusDataEntry
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
        object ade2RLAMB: TArgusDataEntry
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
      object jvsp3PLIN: TJvStandardPage
        Left = 0
        Top = 0
        Width = 382
        Height = 73
        Caption = 'jvsp3PLIN'
        object lbl3SWRES: TLabel
          Left = 16
          Top = 11
          Width = 40
          Height = 13
          Caption = 'SWRES'
        end
        object lbl3RKRES: TLabel
          Left = 24
          Top = 35
          Width = 37
          Height = 13
          Caption = 'RKRES'
        end
        object Label3: TLabel
          Left = 144
          Top = 11
          Width = 166
          Height = 13
          Caption = 'Saturation at which RKRES occurs'
        end
        object Label4: TLabel
          Left = 144
          Top = 35
          Width = 136
          Height = 13
          Caption = 'Minimum relative permeability'
        end
        object ade3SWRES: TArgusDataEntry
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
        object ade3RKRES: TArgusDataEntry
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
      object jvsp4IMPE: TJvStandardPage
        Left = 0
        Top = 0
        Width = 382
        Height = 73
        Caption = 'jvsp4IMPE'
        object lbl4OMPOR: TLabel
          Left = 16
          Top = 11
          Width = 40
          Height = 13
          Caption = 'OMPOR'
        end
        object lbl4RKRES: TLabel
          Left = 24
          Top = 35
          Width = 37
          Height = 13
          Caption = 'RKRES'
        end
        object Label5: TLabel
          Left = 144
          Top = 35
          Width = 136
          Height = 13
          Caption = 'Minimum relative permeability'
        end
        object ade4OMPOR: TArgusDataEntry
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
        object ade4RKRES: TArgusDataEntry
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
      object jvsp5UDEF: TJvStandardPage
        Left = 0
        Top = 0
        Width = 382
        Height = 73
        Caption = 'jvsp5UDEF'
        DesignSize = (
          382
          73)
        object lbl5NRKPAR: TLabel
          Left = 8
          Top = 35
          Width = 45
          Height = 13
          Caption = 'NRKPAR'
        end
        object Label6: TLabel
          Left = 8
          Top = 8
          Width = 165
          Height = 13
          Caption = 'Number of user-defined parameters'
        end
        object ade5NRKPAR: TArgusDataEntry
          Left = 72
          Top = 32
          Width = 65
          Height = 22
          ItemHeight = 13
          TabOrder = 0
          Text = '0'
          OnExit = ade5NRKPARExit
          DataType = dtInteger
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object rdg5RKPAR: TRbwDataGrid4
          Left = 216
          Top = 8
          Width = 157
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
