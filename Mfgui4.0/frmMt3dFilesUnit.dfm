object frmMt3dFiles: TfrmMt3dFiles
  Left = 532
  Top = 168
  HelpContext = 10170
  Caption = 'Select Paths of Mt3d Files'
  ClientHeight = 286
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  inline framFilePath2: TframFilePath
    Left = 0
    Top = 0
    Width = 584
    Height = 49
    Align = alTop
    TabOrder = 0
    TabStop = True
    ExplicitWidth = 584
    inherited lblFileType: TLabel
      Width = 219
      Height = 19
      Caption = 'Unformatted Concentration File'
      ExplicitWidth = 219
      ExplicitHeight = 19
    end
    inherited edFilePath: TEdit
      Width = 500
      Height = 27
      OnChange = framFilePath2edFilePathChange
      ExplicitWidth = 500
      ExplicitHeight = 27
    end
    inherited btnBrowse: TButton
      Left = 507
      ExplicitLeft = 507
    end
    inherited OpenDialogPath: TOpenDialog
      Filter = 
        'Unformatted Concentration Files (*.ucn)|*.ucn|All Files (*.*)|*.' +
        '*'
    end
  end
  inline framFilePath1: TframFilePath
    Left = 0
    Top = 49
    Width = 584
    Height = 49
    Align = alTop
    TabOrder = 1
    TabStop = True
    ExplicitTop = 49
    ExplicitWidth = 584
    inherited lblFileType: TLabel
      Width = 161
      Height = 19
      Caption = 'Grid Configuration File'
      ExplicitWidth = 161
      ExplicitHeight = 19
    end
    inherited edFilePath: TEdit
      Width = 500
      Height = 27
      OnChange = framFilePath1edFilePathChange
      ExplicitWidth = 500
      ExplicitHeight = 27
    end
    inherited btnBrowse: TButton
      Left = 507
      ExplicitLeft = 507
    end
    inherited OpenDialogPath: TOpenDialog
      Filter = 'Grid Configuration Files (*.cnf)|*.cnf|All Files (*.*)|*.*'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 256
    Width = 584
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      584
      30)
    object Label1: TLabel
      Left = 180
      Top = 8
      Width = 39
      Height = 19
      Caption = 'Layer'
    end
    object BitBtn3: TBitBtn
      Left = 347
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkHelp
    end
    object BitBtn2: TBitBtn
      Left = 427
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
    object btnOK: TBitBtn
      Left = 507
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Enabled = False
      TabOrder = 2
      OnClick = btnOKClick
      Kind = bkOK
    end
    object btnRead: TButton
      Left = 0
      Top = 4
      Width = 113
      Height = 25
      Caption = 'Read Data Sets'
      Enabled = False
      TabOrder = 3
      OnClick = btnReadClick
    end
    object seLayer: TSpinEdit
      Left = 120
      Top = 3
      Width = 57
      Height = 29
      MaxValue = 1
      MinValue = 1
      TabOrder = 4
      Value = 1
    end
    object cbLogTransform: TCheckBox
      Left = 224
      Top = 8
      Width = 129
      Height = 17
      Caption = 'Log Transform'
      TabOrder = 5
    end
  end
  object clbDataSets: TCheckListBox
    Left = 0
    Top = 98
    Width = 584
    Height = 158
    Align = alClient
    ItemHeight = 19
    TabOrder = 3
  end
end
