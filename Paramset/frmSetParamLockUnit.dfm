object frmSetParamLock: TfrmSetParamLock
  Left = 259
  Top = 118
  Width = 257
  Height = 640
  Caption = 'Set Parameter Locks'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'ParamSet.hlp'
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 424
    Width = 249
    Height = 189
    Align = alBottom
    TabOrder = 0
    object BitBtn2: TBitBtn
      Left = 91
      Top = 158
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      TabOrder = 0
      Kind = bkCancel
    end
    object BitBtn1: TBitBtn
      Left = 171
      Top = 158
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      TabOrder = 1
      OnClick = BitBtn1Click
      Kind = bkOK
    end
    object BitBtn3: TBitBtn
      Left = 11
      Top = 158
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      TabOrder = 2
      Kind = bkHelp
    end
    object cbLockName: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Lock Name'
      TabOrder = 3
    end
    object cbLockUnits: TCheckBox
      Left = 8
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Lock Units'
      TabOrder = 4
    end
    object cbLockType: TCheckBox
      Left = 8
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Lock Type'
      TabOrder = 5
    end
    object cbLockInfo: TCheckBox
      Left = 8
      Top = 56
      Width = 97
      Height = 17
      Caption = 'Lock Info'
      TabOrder = 6
    end
    object cbLockDefVal: TCheckBox
      Left = 8
      Top = 72
      Width = 97
      Height = 17
      Caption = 'Lock Def Val'
      TabOrder = 7
    end
    object cbDontOverride: TCheckBox
      Left = 8
      Top = 88
      Width = 121
      Height = 17
      Caption = 'Dont Override'
      TabOrder = 8
    end
    object cbInhibitDelete: TCheckBox
      Left = 8
      Top = 104
      Width = 97
      Height = 17
      Caption = 'Inhibit Delete'
      TabOrder = 9
    end
    object cbLockKind: TCheckBox
      Left = 8
      Top = 120
      Width = 121
      Height = 17
      Caption = 'Lock Kind'
      TabOrder = 10
    end
    object cbDontEvalColor: TCheckBox
      Left = 8
      Top = 136
      Width = 121
      Height = 17
      Caption = 'Dont Eval Color'
      TabOrder = 11
    end
  end
  object tvLayers: TTreeView
    Left = 0
    Top = 0
    Width = 249
    Height = 424
    Align = alClient
    Images = ImageList1
    Indent = 19
    ReadOnly = True
    TabOrder = 1
    OnMouseDown = tvLayersMouseDown
  end
  object ImageList1: TImageList
    Left = 96
    Top = 8
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001001000000000000008
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001863186318631863
      1863186318631863186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000C007C007C0070000DFF7DFF7C0070000DFF7DDF7C0070000
      DFF7D8F7C0070000DFF7D277C0070000DFF7D737C0070000DFF7DF97C0070000
      DFF7DFD7C0070000DFF7DFF7C0070000DFF7DFF7C0070000C007C007C0070000
      FFFFFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
end