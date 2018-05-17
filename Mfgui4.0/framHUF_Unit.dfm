object framHUF: TframHUF
  Left = 0
  Top = 0
  Width = 522
  Height = 253
  HelpContext = 240
  TabOrder = 0
  object gbHUF: TGroupBox
    Left = 0
    Top = 0
    Width = 522
    Height = 253
    Align = alClient
    Caption = 'Units for Hydrogeologic Unit Flow package'
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 200
      Width = 518
      Height = 51
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object lblHufUnitCount: TLabel
        Left = 88
        Top = 6
        Width = 77
        Height = 26
        Caption = 'Number of HUF geologic units'
        WordWrap = True
      end
      object adeHufUnitCount: TArgusDataEntry
        Left = 8
        Top = 11
        Width = 73
        Height = 22
        Hint = 'number of hydrogeologic unit'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '1'
        OnExit = adeHufUnitCountExit
        DataType = dtInteger
        Max = 1
        Min = 1
        CheckMin = True
        ChangeDisabledColor = True
      end
      object btnAdd: TButton
        Left = 432
        Top = 8
        Width = 75
        Height = 25
        Hint = 'Add a new hydrogeologic unit.'
        HelpContext = 210
        Caption = '&Add'
        Enabled = False
        TabOrder = 1
        OnClick = btnAddClick
      end
      object btnInsertUnit: TButton
        Left = 352
        Top = 8
        Width = 75
        Height = 25
        Hint = 
          'Insert a new hydrogeologic unit above the selected hydrogeologic' +
          ' unit.'
        HelpContext = 210
        Caption = '&Insert'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnInsertUnitClick
      end
      object btnDeleteUnit: TButton
        Left = 272
        Top = 8
        Width = 75
        Height = 25
        Hint = 'Delete the selected hydrogeologic unit'
        HelpContext = 220
        Caption = '&Delete'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btnDeleteUnitClick
      end
    end
    object dgHufUnits: TDataGrid
      Left = 2
      Top = 15
      Width = 518
      Height = 185
      Hint = 'Non spatial data for hydrogeologic units'
      Align = alClient
      Color = clBtnFace
      ColCount = 3
      DefaultRowHeight = 20
      Enabled = False
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnDrawCell = dgHufUnitsDrawCell
      OnExit = dgHufUnitsExit
      OnSelectCell = dgHufUnitsSelectCell
      OnSetEditText = dgHufUnitsSetEditText
      Columns = <
        item
          MaxLength = 10
          Title.Caption = 'Name'
          Title.WordWrap = False
        end
        item
          Format = cfNumber
          Title.Caption = 'Horizontal Anisotropy Flag'
          Title.WordWrap = False
        end
        item
          Format = cfNumber
          Title.Caption = 'Vertical Anisotropy Flag'
          Title.WordWrap = False
        end>
      RowCountMin = 0
      SelectedIndex = 0
      Version = '2.0'
      ColWidths = (
        122
        200
        173)
    end
  end
end
