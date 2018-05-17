object frmSetParamLock: TfrmSetParamLock
  Left = 672
  Top = 164
  Width = 266
  Height = 640
  HelpContext = 300
  Caption = 'Set Parameter Locks'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  HelpFile = 'Utility.hlp'
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 465
    Width = 258
    Height = 144
    Align = alBottom
    TabOrder = 0
    object BitBtn2: TBitBtn
      Left = 174
      Top = 88
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkCancel
    end
    object BitBtn1: TBitBtn
      Left = 174
      Top = 116
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      OnClick = BitBtn1Click
      Kind = bkOK
    end
    object BitBtn3: TBitBtn
      Left = 174
      Top = 60
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 2
      Kind = bkHelp
    end
    object cbLockName: TCheckBox
      Left = 7
      Top = 7
      Width = 146
      Height = 13
      Caption = 'Lock Name'
      TabOrder = 3
    end
    object cbLockUnits: TCheckBox
      Left = 7
      Top = 22
      Width = 146
      Height = 13
      Caption = 'Lock Units'
      TabOrder = 4
    end
    object cbLockType: TCheckBox
      Left = 7
      Top = 37
      Width = 146
      Height = 13
      Caption = 'Lock Type'
      TabOrder = 5
    end
    object cbLockInfo: TCheckBox
      Left = 7
      Top = 52
      Width = 146
      Height = 13
      Caption = 'Lock Info'
      TabOrder = 6
    end
    object cbLockDefVal: TCheckBox
      Left = 7
      Top = 67
      Width = 146
      Height = 13
      Caption = 'Lock Def Val'
      TabOrder = 7
    end
    object cbDontOverride: TCheckBox
      Left = 7
      Top = 82
      Width = 146
      Height = 13
      Caption = 'Dont Override'
      TabOrder = 8
    end
    object cbInhibitDelete: TCheckBox
      Left = 7
      Top = 97
      Width = 146
      Height = 13
      Caption = 'Inhibit Delete'
      TabOrder = 9
    end
    object cbLockKind: TCheckBox
      Left = 7
      Top = 112
      Width = 146
      Height = 13
      Caption = 'Lock Kind'
      TabOrder = 10
    end
    object cbDontEvalColor: TCheckBox
      Left = 7
      Top = 127
      Width = 146
      Height = 13
      Caption = 'Dont Eval Color'
      TabOrder = 11
    end
    object btnAbout: TButton
      Left = 174
      Top = 32
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'About'
      TabOrder = 12
      OnClick = btnAboutClick
    end
  end
  object vstLayers: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 258
    Height = 465
    Align = alClient
    CheckImageKind = ckFlat
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    TabOrder = 1
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    OnChecked = vstLayersChecked
    OnGetText = vstLayersGetText
    Columns = <>
  end
end
