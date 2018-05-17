inherited frmMain: TfrmMain
  Left = 383
  Top = 233
  Width = 434
  Height = 337
  Caption = 'frmMain'
  PixelsPerInch = 120
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 269
    Width = 426
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 426
    Height = 269
    ActivePage = tab2
    Align = alClient
    TabOrder = 1
    object tab1: TTabSheet
      Caption = 'tab1'
      ImageIndex = 1
      object Label1: TLabel
        Left = 80
        Top = 12
        Width = 50
        Height = 14
        Caption = 'An Integer'
      end
      object Label2: TLabel
        Left = 80
        Top = 44
        Width = 68
        Height = 14
        Caption = 'A real number'
      end
      object Label3: TLabel
        Left = 136
        Top = 76
        Width = 39
        Height = 14
        Caption = 'A String'
      end
      object lblVersionCaption: TLabel
        Left = 8
        Top = 144
        Width = 38
        Height = 14
        Caption = 'Version'
      end
      object lblVersion: TLabel
        Left = 56
        Top = 144
        Width = 48
        Height = 14
        Caption = 'lblVersion'
      end
      object Label6: TLabel
        Left = 136
        Top = 176
        Width = 52
        Height = 14
        Caption = 'Model Path'
      end
      object adeInteger: TArgusDataEntry
        Left = 8
        Top = 8
        Width = 60
        Height = 22
        ItemHeight = 14
        TabOrder = 0
        Text = '0'
        DataType = dtReal
        Max = 1
        CheckMax = True
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeReal: TArgusDataEntry
        Left = 8
        Top = 40
        Width = 60
        Height = 22
        ItemHeight = 14
        TabOrder = 1
        Text = '0'
        DataType = dtInteger
        Max = 1
        ChangeDisabledColor = True
      end
      object edString: TEdit
        Left = 8
        Top = 72
        Width = 121
        Height = 22
        TabOrder = 2
        Text = 'A String'
      end
      object cbOptionalParameter: TCheckBox
        Left = 8
        Top = 104
        Width = 217
        Height = 17
        Caption = 'Include optional parameter on layers'
        TabOrder = 3
        OnClick = cbOptionalParameterClick
      end
      object cbOptionalLayers: TCheckBox
        Left = 8
        Top = 120
        Width = 217
        Height = 17
        Caption = 'Include optional layers'
        TabOrder = 4
        OnClick = cbOptionalLayersClick
      end
      object edModelPath: TEdit
        Left = 8
        Top = 168
        Width = 121
        Height = 22
        TabOrder = 5
      end
    end
    object tab2: TTabSheet
      Caption = 'tab2'
      object Splitter1: TSplitter
        Left = 207
        Top = 0
        Width = 3
        Height = 240
        Cursor = crHSplit
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 207
        Height = 240
        Align = alLeft
        TabOrder = 0
        object sgGeolUnits: TStringGrid
          Left = 1
          Top = 1
          Width = 205
          Height = 175
          Align = alClient
          ColCount = 2
          RowCount = 2
          TabOrder = 0
          ColWidths = (
            25
            166)
        end
        object Panel3: TPanel
          Left = 1
          Top = 176
          Width = 205
          Height = 63
          Align = alBottom
          TabOrder = 1
          object Label4: TLabel
            Left = 8
            Top = 40
            Width = 69
            Height = 14
            Caption = 'Geologic Units'
          end
          object btnAddUnit: TButton
            Left = 8
            Top = 8
            Width = 40
            Height = 25
            Caption = 'Add'
            TabOrder = 0
            OnClick = ChangeNumUnits
          end
          object btnInsertUnit: TButton
            Left = 56
            Top = 8
            Width = 40
            Height = 25
            Caption = 'Insert'
            TabOrder = 1
            OnClick = btnInsertUnitClick
          end
          object btnDeleteUnit: TButton
            Left = 104
            Top = 8
            Width = 40
            Height = 25
            Caption = 'Delete'
            TabOrder = 2
            OnClick = ChangeNumUnits
          end
        end
      end
      object Panel4: TPanel
        Left = 210
        Top = 0
        Width = 208
        Height = 240
        Align = alClient
        TabOrder = 1
        object Panel5: TPanel
          Left = 1
          Top = 176
          Width = 206
          Height = 63
          Align = alBottom
          TabOrder = 0
          object Label5: TLabel
            Left = 8
            Top = 40
            Width = 28
            Height = 14
            Caption = 'Times'
          end
          object btnDeleteTime: TButton
            Left = 104
            Top = 8
            Width = 40
            Height = 25
            Caption = 'Delete'
            TabOrder = 0
            OnClick = btnDeleteTimeClick
          end
          object btnInsertTime: TButton
            Left = 56
            Top = 8
            Width = 40
            Height = 25
            Caption = 'Insert'
            TabOrder = 1
            OnClick = btnInsertTimeClick
          end
          object btnAddTime: TButton
            Left = 8
            Top = 8
            Width = 40
            Height = 25
            Caption = 'Add'
            TabOrder = 2
            OnClick = ChangeNumberOfTimes
          end
        end
        object sgTimes: TStringGrid
          Left = 1
          Top = 1
          Width = 206
          Height = 175
          Align = alClient
          ColCount = 2
          RowCount = 2
          TabOrder = 1
          ColWidths = (
            25
            166)
        end
      end
    end
    object tabProblem: TTabSheet
      Caption = 'tabProblem'
      ImageIndex = 2
      object reProblem: TRichEdit
        Left = 0
        Top = 0
        Width = 418
        Height = 240
        Align = alClient
        TabOrder = 0
      end
    end
  end
end
