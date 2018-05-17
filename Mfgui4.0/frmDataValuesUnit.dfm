object frmDataValues: TfrmDataValues
  Left = 284
  Top = 116
  Width = 192
  Height = 324
  Caption = 'Data Values'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 19
  object dgValues: TDataGrid
    Left = 0
    Top = 65
    Width = 184
    Height = 195
    Align = alClient
    ColCount = 2
    DefaultColWidth = 80
    DefaultRowHeight = 20
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs]
    TabOrder = 1
    OnKeyDown = dgValuesKeyDown
    OnSetEditText = dgValuesSetEditText
    Columns = <
      item
        Title.Caption = 'Parameter'
      end
      item
        Format = cfNumber
        Title.Caption = 'Value'
      end>
    RowCountMin = 0
    SelectedIndex = 1
    Version = '2.0'
    RowHeights = (
      20
      20
      20
      20
      20)
  end
  object Panel1: TPanel
    Left = 0
    Top = 260
    Width = 184
    Height = 32
    Align = alBottom
    TabOrder = 2
    object btnOK: TBitBtn
      Left = 106
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkOK
    end
    object btCancel: TBitBtn
      Left = 26
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 184
    Height = 65
    Align = alTop
    TabOrder = 0
    object lblX: TLabel
      Left = 8
      Top = 11
      Width = 17
      Height = 19
      Caption = 'X:'
    end
    object lblY: TLabel
      Left = 8
      Top = 35
      Width = 16
      Height = 19
      Caption = 'Y:'
    end
    object adeX: TArgusDataEntry
      Left = 24
      Top = 8
      Width = 145
      Height = 22
      ItemHeight = 19
      TabOrder = 0
      Text = '0'
      OnExit = adeXExit
      DataType = dtReal
      Max = 1
      ChangeDisabledColor = True
    end
    object adeY: TArgusDataEntry
      Left = 24
      Top = 32
      Width = 145
      Height = 22
      ItemHeight = 19
      TabOrder = 1
      Text = '0'
      OnExit = adeYExit
      DataType = dtReal
      Max = 1
      ChangeDisabledColor = True
    end
  end
end
