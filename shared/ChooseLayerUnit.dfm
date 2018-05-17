object frmChooseLayer: TfrmChooseLayer
  Left = 543
  Top = 288
  Caption = 'Choose Layer'
  ClientHeight = 326
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 338
    Height = 105
    Align = alTop
    TabOrder = 0
    object lblChoose: TLabel
      Left = 8
      Top = 8
      Width = 278
      Height = 38
      Caption = 'Choose layer or enter the name of a new information layer.'
      WordWrap = True
    end
    object comboLayerNames: TComboBox
      Left = 8
      Top = 48
      Width = 321
      Height = 27
      Style = csDropDownList
      ItemHeight = 19
      TabOrder = 0
    end
    object cbNewLayer: TCheckBox
      Left = 8
      Top = 80
      Width = 97
      Height = 17
      Caption = 'New Layer'
      TabOrder = 1
      OnClick = cbNewLayerClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 285
    Width = 338
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 262
    DesignSize = (
      338
      41)
    object BitBtn2: TBitBtn
      Left = 175
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkCancel
    end
    object BitBtn1: TBitBtn
      Left = 257
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      OnClick = BitBtn1Click
      Kind = bkOK
    end
  end
  object pnlNewLayer: TPanel
    Left = 0
    Top = 105
    Width = 338
    Height = 180
    Align = alClient
    TabOrder = 1
    Visible = False
    ExplicitHeight = 157
    object lblParamCount: TLabel
      Left = 72
      Top = 145
      Width = 239
      Height = 19
      Caption = 'Number of parameters in new layer'
    end
    object seParamCount: TSpinEdit
      Left = 8
      Top = 141
      Width = 57
      Height = 29
      MaxValue = 10000
      MinValue = 1
      TabOrder = 1
      Value = 1
      OnChange = seParamCountChange
    end
    object dgParameters: TDataGrid
      Left = 8
      Top = 8
      Width = 320
      Height = 120
      ColCount = 2
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
      TabOrder = 0
      Columns = <
        item
          Title.Caption = 'Parameter'
          Title.WordWrap = False
        end
        item
          LimitToList = True
          PickList.Strings = (
            'Real'
            'Integer'
            'Boolean'
            'String')
          Title.Caption = 'Type'
          Title.WordWrap = False
        end>
      RowCountMin = 0
      SelectedIndex = 0
      Version = '2.0'
      ColWidths = (
        224
        73)
    end
  end
end
