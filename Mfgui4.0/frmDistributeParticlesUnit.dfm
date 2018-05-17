object frmDistributeParticles: TfrmDistributeParticles
  Left = 353
  Top = 124
  Width = 248
  Height = 144
  HelpContext = 2450
  Caption = 'Distribute Particles'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 19
  object Label1: TLabel
    Left = 80
    Top = 33
    Width = 122
    Height = 19
    Caption = 'Rows of Particles'
  end
  object Label2: TLabel
    Left = 80
    Top = 9
    Width = 145
    Height = 19
    Caption = 'Columns of Particles'
  end
  object Label3: TLabel
    Left = 80
    Top = 57
    Width = 130
    Height = 19
    Caption = 'Layers of Particles'
  end
  object adeRows: TArgusDataEntry
    Left = 8
    Top = 32
    Width = 65
    Height = 22
    ItemHeight = 19
    TabOrder = 1
    Text = '1'
    DataType = dtInteger
    Max = 1
    Min = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object adeCols: TArgusDataEntry
    Left = 8
    Top = 8
    Width = 65
    Height = 22
    ItemHeight = 19
    TabOrder = 0
    Text = '1'
    DataType = dtInteger
    Max = 1
    Min = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object adeLayers: TArgusDataEntry
    Left = 8
    Top = 56
    Width = 65
    Height = 22
    ItemHeight = 19
    TabOrder = 2
    Text = '1'
    DataType = dtInteger
    Max = 1
    Min = 1
    CheckMin = True
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 80
    Top = 80
    Width = 81
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 168
    Top = 80
    Width = 65
    Height = 25
    TabOrder = 4
    Kind = bkOK
  end
  object BitBtn3: TBitBtn
    Left = 8
    Top = 80
    Width = 65
    Height = 25
    TabOrder = 5
    Kind = bkHelp
  end
end
