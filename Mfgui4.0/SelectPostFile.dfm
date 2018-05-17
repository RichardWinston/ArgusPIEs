object frmSelectPostFile: TfrmSelectPostFile
  Left = 302
  Top = 204
  HelpContext = 10040
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Select Data Set'
  ClientHeight = 566
  ClientWidth = 633
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
  PixelsPerInch = 96
  TextHeight = 19
  object rgSourceType: TRadioGroup
    Left = 0
    Top = 25
    Width = 633
    Height = 504
    HelpContext = 10040
    Align = alClient
    Caption = 'Read Output from'
    ItemIndex = 0
    Items.Strings = (
      'MODFLOW (Formatted Head and Drawdown)'
      'MOC3D or MF2K-GWT (Concentrations)'
      'MOC3D or MF2K-GWT (Velocities)'
      'MODFLOW 2000 1% Scaled Sensitivities'
      
        'MODFLOW (Binary  Head and Drawdown) (MODFLOW-2000 v.1.1 or earli' +
        'er)'
      'MODFLOW (Binary IBS Files)'
      
        'MODFLOW (Binary  Head and Drawdown) (MODFLOW-2000 v.1.2 or later' +
        ')'
      'MODFLOW Hydrologic Unit Flow Package formatted head file'
      'MT3DMS or SEAWAT-2000 (Concentration)'
      'MODFLOW Budget file (MODFLOW-2000 v.1.1 or earlier)'
      'MODFLOW Budget file (MODFLOW-2000 v.1.2 or later)'
      'MODFLOW SUB or SWT Packages Subsidence'
      'MODFLOW SUB or SWT Packages Compaction by Model Layer'
      'MODFLOW SUB Package Compaction by Interbed System'
      'MODFLOW SUB or SWT Packages Vertical Displacement by Model Layer'
      'MODFLOW SUB Package Critical Head for No-delay Interbeds'
      'MODFLOW SUB Package Critical Head for Delay Interbeds'
      'MODFLOW Hydrologic Unit Flow Package binary head file'
      'MODFLOW SWT Package Compaction by Interbed System'
      'MODFLOW SWT Package Preconsolidation Stress by Model Layer'
      
        'MODFLOW SWT Package Change in Preconsolidation Stress by Model L' +
        'ayer'
      'MODFLOW SWT Package Geostatic Stress by Model Layer'
      'MODFLOW SWT Package Change in Geostatic Stress by Model Layer'
      'MODFLOW SWT Package Effective Stress by Model Layer'
      'MODFLOW SWT Package Change in Effective Stress by Model Layer'
      'MODFLOW SWT Package Void Ratio by Interbed System'
      
        'MODFLOW SWT Package Thickness of Compressible Sediments by Inter' +
        'bed System'
      'MODFLOW SWT Package Layer-Center Elevation by Model Layer')
    TabOrder = 1
    OnClick = rgSourceTypeClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Turn off "Special|Manual Calculation" if it is on.'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 529
    Width = 633
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      633
      37)
    object BitBtn3: TBitBtn
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      HelpContext = 10040
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkHelp
    end
    object BitBtn1: TBitBtn
      Left = 424
      Top = 8
      Width = 75
      Height = 25
      HelpContext = 10040
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
    object btnSelect: TButton
      Left = 504
      Top = 8
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Select Data Set'
      TabOrder = 2
      OnClick = btnSelectClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Formatted Head and Drawdown (*.FHD;*.FDN)|*.FHD;*.FDN|Formatted ' +
      'Head (*.FHD)|*.FHD|Formatted Drawdown (*.FDN)|*.FDN|All Files (*' +
      '.*)|*.*'
    Left = 192
    Top = 40
  end
end
