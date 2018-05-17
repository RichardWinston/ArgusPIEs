object frmSutraPriorEquationEditor: TfrmSutraPriorEquationEditor
  Left = 430
  Top = 212
  Width = 285
  Height = 297
  Caption = 'Prior Equation Editor'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object dgEquationParts: TDataGrid
    Left = 0
    Top = 0
    Width = 277
    Height = 176
    Align = alClient
    ColCount = 2
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
    TabOrder = 0
    Columns = <
      item
        Format = cfNumber
        Title.Caption = 'Coefficient'
        Title.WordWrap = False
      end
      item
        LimitToList = True
        Title.Caption = 'Parameter Search-string'
        Title.WordWrap = False
      end>
    RowCountMin = 0
    OnUserChanged = dgEquationPartsUserChanged
    SelectedIndex = 0
    Version = '2.0'
    ColWidths = (
      95
      171)
  end
  object Panel1: TPanel
    Left = 0
    Top = 176
    Width = 277
    Height = 68
    Align = alBottom
    TabOrder = 1
    object lblParamCount: TLabel
      Left = 80
      Top = 12
      Width = 76
      Height = 19
      Caption = 'Row Count'
    end
    object BitBtn1: TBitBtn
      Left = 120
      Top = 40
      Width = 73
      Height = 25
      TabOrder = 0
      Kind = bkCancel
    end
    object BitBtn2: TBitBtn
      Left = 200
      Top = 40
      Width = 73
      Height = 25
      TabOrder = 1
      Kind = bkOK
    end
    object BitBtn3: TBitBtn
      Left = 40
      Top = 40
      Width = 73
      Height = 25
      TabOrder = 2
      OnClick = BitBtn3Click
      Kind = bkHelp
    end
    object seParameterCount: TJvSpinEdit
      Left = 8
      Top = 8
      Width = 65
      Height = 27
      CheckMaxValue = False
      ButtonKind = bkClassic
      MinValue = 1
      Value = 1
      TabOrder = 3
      OnChange = adeParamCountExit
    end
  end
  object sbEquation: TStatusBar
    Left = 0
    Top = 244
    Width = 277
    Height = 19
    Panels = <>
    SimplePanel = True
  end
end
