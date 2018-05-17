object frmMODFLOWPostProcessing: TfrmMODFLOWPostProcessing
  Left = 531
  Top = 215
  HelpContext = 10050
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'MODFLOW Post-Processing'
  ClientHeight = 529
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object spl1: TSplitter
    Left = 0
    Top = 307
    Width = 336
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 310
  end
  object Panel1: TPanel
    Left = 0
    Top = 310
    Width = 336
    Height = 219
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      336
      219)
    object Label1: TLabel
      Left = 8
      Top = 108
      Width = 51
      Height = 19
      Caption = 'Layers:'
    end
    object rgChartType: TRadioGroup
      Left = 8
      Top = 8
      Width = 313
      Height = 97
      HelpContext = 10100
      Caption = 'Chart Type'
      ItemIndex = 2
      Items.Strings = (
        'Three-Dimensional Surface Map'
        'Color Map'
        'Contour Map'
        'Cross Section')
      TabOrder = 0
    end
    object btnCancel: TBitBtn
      Left = 164
      Top = 189
      Width = 75
      Height = 25
      HelpContext = 10160
      TabOrder = 5
      Kind = bkCancel
    end
    object btnOK: TBitBtn
      Left = 245
      Top = 189
      Width = 75
      Height = 25
      HelpContext = 10150
      TabOrder = 6
      OnClick = btnOKClick
      Kind = bkOK
    end
    object btnHelp: TBitBtn
      Left = 245
      Top = 158
      Width = 75
      Height = 25
      HelpContext = 10050
      TabOrder = 4
      Kind = bkHelp
    end
    object cbImpInactive: TCheckBox
      Left = 160
      Top = 128
      Width = 161
      Height = 17
      HelpContext = 10080
      Caption = 'Import inactive cells'
      TabOrder = 2
    end
    object cbImpDry: TCheckBox
      Left = 160
      Top = 112
      Width = 137
      Height = 17
      HelpContext = 10090
      Caption = 'Import dry cells'
      TabOrder = 1
    end
    object clLayerNumber: TCheckListBox
      Left = 8
      Top = 130
      Width = 121
      Height = 73
      HelpContext = 10070
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 19
      TabOrder = 3
    end
  end
  object clDataSets: TCheckListBox
    Left = 0
    Top = 0
    Width = 336
    Height = 307
    HelpContext = 10060
    Align = alClient
    ItemHeight = 19
    TabOrder = 0
    ExplicitHeight = 310
  end
end
