object frmRun: TfrmRun
  Left = 276
  Top = 11
  HelpContext = 11040
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Run model'
  ClientHeight = 713
  ClientWidth = 772
  Color = clBtnFace
  Constraints.MinHeight = 384
  Constraints.MinWidth = 472
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object sbModelStatus: TStatusBar
    Left = 0
    Top = 694
    Width = 772
    Height = 19
    Panels = <
      item
        Style = psOwnerDraw
        Width = 50
      end>
    OnDrawPanel = sbModelStatusDrawPanel
  end
  object pcRun: TPageControl
    Left = 0
    Top = 0
    Width = 772
    Height = 657
    ActivePage = tabModelChoice
    Align = alClient
    TabOrder = 0
    OnChange = pcRunChange
    object tabModelChoice: TTabSheet
      Caption = 'Model Options'
      object lblWarning1: TLabel
        Left = 5
        Top = 520
        Width = 227
        Height = 45
        Caption = 
          'Warning: If the MODFLOW FD Grid layer has been altered, all MODF' +
          'LOW packages should be re-exported'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object lblRootname: TLabel
        Left = 8
        Top = 4
        Width = 230
        Height = 15
        Caption = 'Root name for MODFLOW simulation files:'
      end
      object lblDiscretization: TLabel
        Left = 312
        Top = 612
        Width = 249
        Height = 15
        Caption = 'Name of Modflow-2000 style discretization file:'
      end
      object lblMT3DWarning2: TLabel
        Left = 4
        Top = 576
        Width = 260
        Height = 30
        Caption = 
          'Warning: If the MODFLOW model has been changed, it must be re-ru' +
          'n before running MT3D.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object gboxRunOption: TGroupBox
        Left = 4
        Top = 24
        Width = 293
        Height = 433
        HelpContext = 11050
        Caption = 'Run options'
        TabOrder = 1
        object lblMODFLOWCreate: TLabel
          Left = 26
          Top = 160
          Width = 80
          Height = 15
          Caption = 'input files only'
        end
        object rbRun: TRadioButton
          Left = 8
          Top = 80
          Width = 281
          Height = 17
          HelpContext = 11050
          Caption = '&Create input files and run MODFLOW or MOC3D'
          Checked = True
          TabOrder = 1
          TabStop = True
          OnClick = ModelButtonClick
        end
        object cbUseSolute: TCheckBox
          Left = 24
          Top = 96
          Width = 257
          Height = 17
          HelpContext = 11050
          Caption = '&Include MOC3D to simulate solute transport'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = ModelButtonClick
        end
        object rbCreate: TRadioButton
          Left = 8
          Top = 144
          Width = 273
          Height = 17
          HelpContext = 11050
          Caption = 'Create MODFLOW and/or MOC3D'
          TabOrder = 5
          OnClick = ModelButtonClick
        end
        object rbRunZonebudget: TRadioButton
          Left = 8
          Top = 224
          Width = 249
          Height = 17
          HelpContext = 11050
          Caption = 'Create input files and run ZONEBUDGET'
          TabOrder = 8
          OnClick = ModelButtonClick
        end
        object rbCreateZonebudget: TRadioButton
          Left = 8
          Top = 240
          Width = 241
          Height = 17
          HelpContext = 11050
          Caption = 'Create ZONEBUDGET input files only'
          TabOrder = 9
          OnClick = ModelButtonClick
        end
        object rbMPATHRun: TRadioButton
          Left = 8
          Top = 184
          Width = 225
          Height = 17
          HelpContext = 11050
          Caption = 'Create input files and run MODPATH'
          TabOrder = 6
          OnClick = ModelButtonClick
        end
        object rbMPATHCreate: TRadioButton
          Left = 8
          Top = 200
          Width = 201
          Height = 17
          HelpContext = 11050
          Caption = 'Create MODPATH input files only'
          TabOrder = 7
          OnClick = ModelButtonClick
        end
        object cbResan: TCheckBox
          Left = 24
          Top = 112
          Width = 145
          Height = 17
          Caption = 'Use Resan-2000'
          TabOrder = 3
          OnClick = adeModelPathChange
        end
        object rbYcint: TRadioButton
          Left = 8
          Top = 264
          Width = 201
          Height = 17
          HelpContext = 11050
          Caption = 'Run YCINT-2000'
          TabOrder = 10
          OnClick = ModelButtonClick
        end
        object rbBeale: TRadioButton
          Left = 8
          Top = 288
          Width = 201
          Height = 17
          HelpContext = 11050
          Caption = 'Run BEALE-2000'
          TabOrder = 11
          OnClick = ModelButtonClick
        end
        object rgModflowVersion: TRadioGroup
          Left = 8
          Top = 16
          Width = 281
          Height = 57
          Caption = 'Modflow Version'
          Columns = 2
          ItemIndex = 1
          Items.Strings = (
            'MODFLOW-96'
            'MODFLOW-2000'
            'MODFLOW-2005')
          TabOrder = 0
          OnClick = cbModflow2000Click
        end
        object rbRunMT3D: TRadioButton
          Left = 8
          Top = 312
          Width = 193
          Height = 17
          Caption = 'Create input files and run MT3D'
          Enabled = False
          TabOrder = 12
          OnClick = ModelButtonClick
        end
        object rbCreateMT3D: TRadioButton
          Left = 8
          Top = 328
          Width = 193
          Height = 17
          Caption = 'Create MT3D input files only'
          Enabled = False
          TabOrder = 13
          OnClick = ModelButtonClick
        end
        object cbUseMT3D: TCheckBox
          Left = 24
          Top = 128
          Width = 257
          Height = 17
          HelpContext = 11050
          Caption = 'Create MT3DMS Link file'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = ModelButtonClick
        end
        object rbRunSeawat: TRadioButton
          Left = 8
          Top = 352
          Width = 257
          Height = 17
          Caption = 'Create input files and run SEAWAT-2000'
          Enabled = False
          TabOrder = 14
          OnClick = ModelButtonClick
        end
        object rbCreateSeaWat: TRadioButton
          Left = 8
          Top = 368
          Width = 257
          Height = 17
          Caption = 'Create SEAWAT-2000 input files only'
          Enabled = False
          TabOrder = 15
          OnClick = ModelButtonClick
        end
        object rbRunGWM: TRadioButton
          Left = 8
          Top = 392
          Width = 257
          Height = 17
          Caption = 'Create input files and run MODFLOW-GWM'
          Enabled = False
          TabOrder = 16
          OnClick = ModelButtonClick
        end
        object rbCreateGWM: TRadioButton
          Left = 8
          Top = 408
          Width = 257
          Height = 17
          Caption = 'Create MODFLOW-GWM input files only'
          Enabled = False
          TabOrder = 17
          OnClick = ModelButtonClick
        end
      end
      object cbCalibrate: TCheckBox
        Left = 4
        Top = 464
        Width = 285
        Height = 17
        HelpContext = 11110
        Caption = '&External calibration program running Argus ONE'
        TabOrder = 4
      end
      object cbShowWarnings: TCheckBox
        Left = 4
        Top = 480
        Width = 261
        Height = 17
        HelpContext = 11120
        Caption = '&Show error and warning messages'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object adeFileName: TArgusDataEntry
        Left = 248
        Top = 0
        Width = 145
        Height = 22
        HelpContext = 1370
        ItemHeight = 15
        MaxLength = 8
        TabOrder = 0
        Text = 'userspec'
        OnEnter = adeFileNameEnter
        OnExit = adeFileNameExit
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object cbProgressBar: TCheckBox
        Left = 4
        Top = 496
        Width = 149
        Height = 17
        Caption = 'Use Progress Bar PIE'
        Checked = True
        State = cbChecked
        TabOrder = 6
        Visible = False
        OnClick = cbProgressBarClick
      end
      object comboDiscretization: TComboBox
        Left = 565
        Top = 608
        Width = 193
        Height = 23
        ItemHeight = 15
        TabOrder = 8
        Text = 'discret.dat'
        Items.Strings = (
          'userspec.dis'
          'discret.dat')
      end
      object gboxMT3DPackages: TGroupBox
        Left = 316
        Top = 458
        Width = 445
        Height = 87
        Caption = 'MT3DMS input files'
        TabOrder = 3
        object lblMT3DBasic: TLabel
          Left = 8
          Top = 16
          Width = 85
          Height = 15
          Caption = 'Basic Transport'
        end
        object lblMT3DAdvec: TLabel
          Left = 8
          Top = 32
          Width = 57
          Height = 15
          Caption = 'Advection'
        end
        object lblMT3DDisp: TLabel
          Left = 8
          Top = 48
          Width = 58
          Height = 15
          Caption = 'Dispersion'
        end
        object lblSourceSink: TLabel
          Left = 232
          Top = 16
          Width = 126
          Height = 15
          Caption = 'Source and Sink Mixing'
        end
        object lblMT3DReact: TLabel
          Left = 232
          Top = 32
          Width = 98
          Height = 15
          Caption = 'Chemical Reaction'
        end
        object lblExportMT3DGCG: TLabel
          Left = 232
          Top = 48
          Width = 122
          Height = 30
          Caption = 'Generalized Conjugate Gradient Solver'
          WordWrap = True
        end
        object cbExportMT3DBTN: TCheckBox
          Left = 168
          Top = 16
          Width = 50
          Height = 17
          Caption = 'BTN'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbExportMT3DADV: TCheckBox
          Left = 168
          Top = 32
          Width = 50
          Height = 17
          Caption = 'ADV'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object cbExportMT3DDSP: TCheckBox
          Left = 168
          Top = 48
          Width = 50
          Height = 17
          Caption = 'DSP'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object cbExportMT3DSSM: TCheckBox
          Left = 384
          Top = 16
          Width = 50
          Height = 17
          Caption = 'SSM'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object cbExportMT3DRCT: TCheckBox
          Left = 384
          Top = 32
          Width = 50
          Height = 17
          Caption = 'RCT'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object cbExportMT3DGCG: TCheckBox
          Left = 384
          Top = 55
          Width = 50
          Height = 17
          Caption = 'GCG'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
      end
      object gbMODPATH: TGroupBox
        Left = 316
        Top = 546
        Width = 445
        Height = 57
        Caption = 'MODPATH input files'
        TabOrder = 7
        object lblMPA: TLabel
          Left = 8
          Top = 16
          Width = 78
          Height = 15
          Caption = 'Main Data File'
        end
        object lblPRT: TLabel
          Left = 8
          Top = 32
          Width = 61
          Height = 15
          Caption = 'Particle File'
        end
        object cbMPA: TCheckBox
          Left = 168
          Top = 16
          Width = 65
          Height = 17
          Caption = '(MPA)'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbPRT: TCheckBox
          Left = 168
          Top = 32
          Width = 65
          Height = 17
          Caption = '(PRT)'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object pcCreateInputFor: TPageControl
        Left = 312
        Top = 32
        Width = 449
        Height = 417
        ActivePage = tabGroup3
        TabOrder = 2
        object tabGroup1: TTabSheet
          Caption = 'Group 1'
          object gboxMFOutputPackages: TGroupBox
            Left = 0
            Top = 0
            Width = 441
            Height = 387
            HelpContext = 11060
            Align = alClient
            Caption = 'Create input files for...'
            TabOrder = 0
            object lblBAS: TLabel
              Left = 8
              Top = 16
              Width = 76
              Height = 15
              Caption = 'Basic package'
            end
            object lblOC: TLabel
              Left = 8
              Top = 80
              Width = 82
              Height = 15
              Caption = 'Output control:'
            end
            object lblBCF: TLabel
              Left = 8
              Top = 112
              Width = 114
              Height = 15
              Caption = 'Block-Centered Flow:'
            end
            object lblRCH: TLabel
              Left = 8
              Top = 128
              Width = 53
              Height = 15
              Caption = 'Recharge:'
            end
            object lblRIV: TLabel
              Left = 8
              Top = 144
              Width = 37
              Height = 15
              Caption = 'Rivers:'
            end
            object lblWEL: TLabel
              Left = 8
              Top = 160
              Width = 33
              Height = 15
              Caption = 'Wells:'
            end
            object lblDRN: TLabel
              Left = 8
              Top = 176
              Width = 38
              Height = 15
              Caption = 'Drains:'
            end
            object lblGHB: TLabel
              Left = 8
              Top = 208
              Width = 139
              Height = 15
              Caption = 'General-Head Boundaries:'
            end
            object lblEVT: TLabel
              Left = 8
              Top = 256
              Width = 105
              Height = 15
              Caption = 'Evapotranspiration:'
            end
            object lblStream: TLabel
              Left = 8
              Top = 224
              Width = 45
              Height = 15
              Caption = 'Streams:'
            end
            object lblDis: TLabel
              Left = 8
              Top = 32
              Width = 76
              Height = 15
              Caption = 'Discretization '
            end
            object lblLPF: TLabel
              Left = 8
              Top = 96
              Width = 112
              Height = 15
              Caption = 'Layer-Property Flow:'
            end
            object lblMult: TLabel
              Left = 8
              Top = 48
              Width = 52
              Height = 15
              Caption = 'Multiplier'
            end
            object lblZONE: TLabel
              Left = 8
              Top = 64
              Width = 34
              Height = 15
              Caption = 'Zones'
            end
            object lblExpSfr: TLabel
              Left = 8
              Top = 240
              Width = 108
              Height = 15
              Caption = 'Streamflow Routing:'
            end
            object lblExpETS: TLabel
              Left = 8
              Top = 273
              Width = 160
              Height = 15
              Caption = 'Evapotranspiration Segments:'
            end
            object lblExpDRT: TLabel
              Left = 8
              Top = 192
              Width = 71
              Height = 15
              Caption = 'Drain Return:'
            end
            object lblExpHYD: TLabel
              Left = 8
              Top = 289
              Width = 59
              Height = 15
              Caption = 'HYDMOD:'
            end
            object lblExpCHD: TLabel
              Left = 8
              Top = 305
              Width = 145
              Height = 15
              Caption = 'Constant-Head Boundaries'
            end
            object lblExpHUF: TLabel
              Left = 8
              Top = 321
              Width = 136
              Height = 15
              Caption = 'Hydrogeologic-Unit Flow'
            end
            object lblExpModelViewer: TLabel
              Left = 8
              Top = 336
              Width = 150
              Height = 15
              Caption = 'Elevations for Model Viewer'
            end
            object cbBAS: TCheckBox
              Left = 168
              Top = 16
              Width = 60
              Height = 17
              HelpContext = 11060
              Caption = 'BAS'
              Checked = True
              State = cbChecked
              TabOrder = 0
            end
            object cbOC: TCheckBox
              Left = 168
              Top = 80
              Width = 60
              Height = 17
              HelpContext = 11060
              Caption = 'OC'
              Checked = True
              State = cbChecked
              TabOrder = 4
            end
            object cbBCF: TCheckBox
              Left = 168
              Top = 112
              Width = 49
              Height = 17
              HelpContext = 11060
              Caption = 'BCF'
              Checked = True
              State = cbChecked
              TabOrder = 6
            end
            object cbRCH: TCheckBox
              Left = 168
              Top = 128
              Width = 49
              Height = 17
              HelpContext = 11060
              Caption = 'RCH'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 7
            end
            object cbRIV: TCheckBox
              Left = 168
              Top = 144
              Width = 60
              Height = 17
              HelpContext = 11060
              Caption = 'RIV'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 8
            end
            object cbWEL: TCheckBox
              Left = 168
              Top = 160
              Width = 60
              Height = 17
              HelpContext = 11060
              Caption = 'WEL'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 9
            end
            object cbDRN: TCheckBox
              Left = 168
              Top = 176
              Width = 60
              Height = 17
              HelpContext = 11060
              Caption = 'DRN'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 10
            end
            object cbGHB: TCheckBox
              Left = 168
              Top = 208
              Width = 60
              Height = 17
              HelpContext = 11060
              Caption = 'GHB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 12
            end
            object cbEVT: TCheckBox
              Left = 168
              Top = 256
              Width = 60
              Height = 17
              HelpContext = 11060
              Caption = 'EVT'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 15
            end
            object cbSTR: TCheckBox
              Left = 168
              Top = 224
              Width = 49
              Height = 17
              Caption = 'STR'
              Checked = True
              State = cbChecked
              TabOrder = 13
            end
            object cbDIS: TCheckBox
              Left = 168
              Top = 32
              Width = 50
              Height = 17
              Caption = 'DIS'
              Checked = True
              State = cbChecked
              TabOrder = 1
            end
            object cbLPF: TCheckBox
              Left = 168
              Top = 96
              Width = 49
              Height = 17
              HelpContext = 11060
              Caption = 'LPF'
              Checked = True
              State = cbChecked
              TabOrder = 5
            end
            object cbMULT: TCheckBox
              Left = 168
              Top = 48
              Width = 57
              Height = 17
              Caption = 'MULT'
              Checked = True
              State = cbChecked
              TabOrder = 2
            end
            object cbZONE: TCheckBox
              Left = 168
              Top = 64
              Width = 57
              Height = 17
              Caption = 'ZONE'
              Checked = True
              State = cbChecked
              TabOrder = 3
            end
            object cbSfr: TCheckBox
              Left = 168
              Top = 240
              Width = 49
              Height = 17
              Caption = 'SFR'
              Checked = True
              State = cbChecked
              TabOrder = 14
            end
            object cbExpETS: TCheckBox
              Left = 168
              Top = 272
              Width = 49
              Height = 17
              Caption = 'ETS'
              Checked = True
              State = cbChecked
              TabOrder = 16
            end
            object cbExpDRT: TCheckBox
              Left = 168
              Top = 192
              Width = 60
              Height = 17
              HelpContext = 11060
              Caption = 'DRT'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 11
            end
            object cbExpHYD: TCheckBox
              Left = 168
              Top = 288
              Width = 49
              Height = 17
              Caption = 'HYD'
              Checked = True
              State = cbChecked
              TabOrder = 17
            end
            object cbExpCHD: TCheckBox
              Left = 168
              Top = 304
              Width = 57
              Height = 17
              Caption = 'CHD'
              Checked = True
              State = cbChecked
              TabOrder = 18
            end
            object cbExpHUF: TCheckBox
              Left = 168
              Top = 320
              Width = 57
              Height = 17
              Caption = 'HUF2'
              Checked = True
              State = cbChecked
              TabOrder = 19
            end
            object cbExpModelViewer: TCheckBox
              Left = 168
              Top = 336
              Width = 57
              Height = 17
              Caption = 'ELEV'
              Checked = True
              State = cbChecked
              TabOrder = 20
            end
          end
        end
        object tabGroup2: TTabSheet
          Caption = 'Group 2'
          ImageIndex = 1
          object gboxMFOutputPackages2: TGroupBox
            Left = 0
            Top = 0
            Width = 441
            Height = 387
            Align = alClient
            Caption = 'Create input files for...'
            TabOrder = 0
            object lblFHBExport: TLabel
              Left = 8
              Top = 16
              Width = 139
              Height = 15
              Caption = 'Flow and Head Boundary:'
            end
            object lblExpSub: TLabel
              Left = 8
              Top = 32
              Width = 62
              Height = 15
              Caption = 'Subsidence'
            end
            object lblExpGAG: TLabel
              Left = 8
              Top = 64
              Width = 27
              Height = 15
              Caption = 'Gage'
            end
            object lblExpIBS: TLabel
              Left = 8
              Top = 80
              Width = 93
              Height = 15
              Caption = 'Interbed-Storage:'
            end
            object lblExpLAK: TLabel
              Left = 8
              Top = 96
              Width = 34
              Height = 15
              Caption = 'Lakes:'
            end
            object lblExpRES: TLabel
              Left = 8
              Top = 112
              Width = 51
              Height = 15
              Caption = 'Reservoir'
            end
            object lblExpTLK: TLabel
              Left = 8
              Top = 128
              Width = 104
              Height = 15
              Caption = 'Transient Leakage: '
            end
            object lblHFT: TLabel
              Left = 8
              Top = 144
              Width = 129
              Height = 15
              Caption = 'Horizontal-Flow Barrier: '
            end
            object lblExpMNW: TLabel
              Left = 8
              Top = 160
              Width = 139
              Height = 15
              Caption = 'Multi-Node Well Package:'
            end
            object lblExpDAFLOW: TLabel
              Left = 8
              Top = 188
              Width = 55
              Height = 15
              Caption = 'DAFLOW'
            end
            object lblExpVdf: TLabel
              Left = 8
              Top = 206
              Width = 116
              Height = 15
              Caption = 'Variable Density Flow'
            end
            object lblMatrix: TLabel
              Left = 8
              Top = 222
              Width = 131
              Height = 15
              Caption = 'Matrix Solution Method:'
            end
            object lblRVOB: TLabel
              Left = 8
              Top = 238
              Width = 106
              Height = 15
              Caption = 'River Observations:'
            end
            object lblHOB: TLabel
              Left = 8
              Top = 254
              Width = 106
              Height = 15
              Caption = 'Head Observations:'
            end
            object lblDROB: TLabel
              Left = 8
              Top = 270
              Width = 107
              Height = 15
              Caption = 'Drain Observations:'
            end
            object lblDTOB: TLabel
              Left = 8
              Top = 286
              Width = 146
              Height = 15
              Caption = 'Drain Return Observations:'
            end
            object lblGBOB: TLabel
              Left = 8
              Top = 302
              Width = 103
              Height = 15
              Caption = 'GHB Observations:'
            end
            object lblSTOB: TLabel
              Left = 8
              Top = 318
              Width = 114
              Height = 15
              Caption = 'Stream Observations:'
            end
            object lblCHOB: TLabel
              Left = 8
              Top = 334
              Width = 114
              Height = 15
              Caption = 'Pres.-Head Flux Obs.:'
            end
            object lblADOB: TLabel
              Left = 8
              Top = 350
              Width = 88
              Height = 15
              Caption = 'Advection Obs.:'
            end
            object lblExpSwt: TLabel
              Left = 8
              Top = 48
              Width = 153
              Height = 15
              Caption = 'Subsidence for WT Aquifers'
            end
            object Label3: TLabel
              Left = 8
              Top = 175
              Width = 145
              Height = 15
              Caption = 'Multi-Node Well2 Package:'
            end
            object cbExpFHB: TCheckBox
              Left = 168
              Top = 16
              Width = 41
              Height = 17
              HelpContext = 11060
              Caption = 'FHB'
              Checked = True
              State = cbChecked
              TabOrder = 0
            end
            object cbExpSub: TCheckBox
              Left = 168
              Top = 32
              Width = 57
              Height = 17
              HelpContext = 11060
              Caption = 'SUB'
              Checked = True
              State = cbChecked
              TabOrder = 1
            end
            object cbExpGAG: TCheckBox
              Left = 168
              Top = 64
              Width = 49
              Height = 17
              Caption = 'GAG'
              Checked = True
              State = cbChecked
              TabOrder = 3
            end
            object cbADOB: TCheckBox
              Left = 168
              Top = 351
              Width = 53
              Height = 17
              HelpContext = 11060
              Caption = 'ADOB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 21
            end
            object cbCHOB: TCheckBox
              Left = 168
              Top = 336
              Width = 53
              Height = 17
              HelpContext = 11060
              Caption = 'CHOB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 20
            end
            object cbSTOB: TCheckBox
              Left = 168
              Top = 319
              Width = 53
              Height = 17
              HelpContext = 11060
              Caption = 'STOB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 19
            end
            object cbGBOB: TCheckBox
              Left = 168
              Top = 303
              Width = 53
              Height = 17
              HelpContext = 11060
              Caption = 'GBOB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 18
            end
            object cbDTOB: TCheckBox
              Left = 168
              Top = 287
              Width = 53
              Height = 17
              HelpContext = 11060
              Caption = 'DTOB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 17
            end
            object cbDROB: TCheckBox
              Left = 168
              Top = 271
              Width = 53
              Height = 17
              HelpContext = 11060
              Caption = 'DROB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 16
            end
            object cbHOB: TCheckBox
              Left = 168
              Top = 255
              Width = 53
              Height = 17
              Caption = 'HOB'
              Checked = True
              State = cbChecked
              TabOrder = 15
            end
            object cbRVOB: TCheckBox
              Left = 168
              Top = 239
              Width = 53
              Height = 17
              HelpContext = 11060
              Caption = 'RVOB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 14
            end
            object cbMatrix: TCheckBox
              Left = 168
              Top = 223
              Width = 52
              Height = 17
              HelpContext = 11060
              Checked = True
              State = cbChecked
              TabOrder = 13
            end
            object cbExpVdf: TCheckBox
              Left = 168
              Top = 207
              Width = 41
              Height = 17
              HelpContext = 11060
              Caption = 'VDF'
              Checked = True
              State = cbChecked
              TabOrder = 12
            end
            object cbExpDAFLOW: TCheckBox
              Left = 168
              Top = 191
              Width = 49
              Height = 17
              Caption = 'DAF'
              Checked = True
              State = cbChecked
              TabOrder = 11
            end
            object cbExpMNW: TCheckBox
              Left = 168
              Top = 160
              Width = 57
              Height = 17
              Caption = 'MNW'
              Checked = True
              State = cbChecked
              TabOrder = 9
            end
            object cbExpHFB: TCheckBox
              Left = 168
              Top = 144
              Width = 49
              Height = 17
              HelpContext = 11060
              Caption = 'HFB'
              Checked = True
              State = cbChecked
              TabOrder = 8
            end
            object cbExpTLK: TCheckBox
              Left = 168
              Top = 128
              Width = 41
              Height = 17
              Caption = 'TLK'
              Checked = True
              State = cbChecked
              TabOrder = 7
            end
            object cbExpRES: TCheckBox
              Left = 168
              Top = 112
              Width = 41
              Height = 17
              Caption = 'RES'
              Checked = True
              State = cbChecked
              TabOrder = 6
            end
            object cbExpLAK: TCheckBox
              Left = 168
              Top = 96
              Width = 49
              Height = 17
              Caption = 'LAK'
              Checked = True
              State = cbChecked
              TabOrder = 5
            end
            object cbExpIBS: TCheckBox
              Left = 168
              Top = 80
              Width = 41
              Height = 17
              Caption = 'IBS'
              Checked = True
              State = cbChecked
              TabOrder = 4
            end
            object cbExpSwt: TCheckBox
              Left = 168
              Top = 48
              Width = 57
              Height = 17
              HelpContext = 11060
              Caption = 'SWT'
              Checked = True
              State = cbChecked
              TabOrder = 2
            end
            object cbExpMnw2: TCheckBox
              Left = 168
              Top = 175
              Width = 57
              Height = 17
              Caption = 'MNW2'
              Checked = True
              State = cbChecked
              TabOrder = 10
            end
          end
        end
        object tabGroup3: TTabSheet
          Caption = 'Group 3'
          ImageIndex = 2
          object gboxMFOutputPackages3: TGroupBox
            Left = 0
            Top = 0
            Width = 441
            Height = 387
            Align = alClient
            Caption = 'Create input files for...'
            TabOrder = 0
            ExplicitTop = 7
            object lblPESExport: TLabel
              Left = 8
              Top = 32
              Width = 117
              Height = 15
              Caption = 'Parameter Estimation: '
            end
            object lblMOC3DSolute: TLabel
              Left = 8
              Top = 48
              Width = 93
              Height = 15
              Caption = 'Solute Transport:'
            end
            object lblMOC3DObsWells: TLabel
              Left = 8
              Top = 64
              Width = 149
              Height = 15
              Caption = 'MOC3D Observation Wells:'
            end
            object lblExpIPDA: TLabel
              Left = 8
              Top = 80
              Width = 110
              Height = 15
              Caption = 'GWT Initial Particles'
            end
            object lblExpBFLX: TLabel
              Left = 8
              Top = 96
              Width = 78
              Height = 15
              Caption = 'Boundary Flux'
            end
            object lblExpCBDY: TLabel
              Left = 8
              Top = 112
              Width = 194
              Height = 15
              Caption = 'Concentration on Subgrid Boundary'
            end
            object lblFTI: TLabel
              Left = 8
              Top = 176
              Width = 93
              Height = 15
              Caption = 'MT3D Link Input'
            end
            object lblGWM_DECVAR: TLabel
              Left = 8
              Top = 192
              Width = 134
              Height = 15
              Caption = 'GWM Decision Variables'
            end
            object lblGWM_OBJFNC: TLabel
              Left = 8
              Top = 208
              Width = 138
              Height = 15
              Caption = 'GWM Objective Function'
            end
            object lblGWM_VARCON: TLabel
              Left = 8
              Top = 224
              Width = 193
              Height = 15
              Caption = 'GWM Decision Variable Constraints'
            end
            object lblGWM_SUMCON: TLabel
              Left = 8
              Top = 240
              Width = 190
              Height = 15
              Caption = 'GWM Linear Sumation  Constraints'
            end
            object lblGWM_HEDCON: TLabel
              Left = 8
              Top = 256
              Width = 129
              Height = 15
              Caption = 'GWM Head Constraints'
            end
            object lblGWM_STRMCON: TLabel
              Left = 8
              Top = 272
              Width = 137
              Height = 15
              Caption = 'GWM Stream Constraints'
            end
            object lblGWM_SOLN: TLabel
              Left = 8
              Top = 306
              Width = 188
              Height = 15
              Caption = 'GWM Solution and Output Control'
            end
            object lblExpPTOB: TLabel
              Left = 8
              Top = 128
              Width = 136
              Height = 15
              Caption = 'Particle Observations File'
            end
            object Label1: TLabel
              Left = 8
              Top = 320
              Width = 126
              Height = 15
              Caption = 'Unsaturated Zone Flow'
            end
            object lblSEN: TLabel
              Left = 8
              Top = 16
              Width = 60
              Height = 15
              Caption = 'Sensitivity:'
            end
            object Label2: TLabel
              Left = 8
              Top = 336
              Width = 112
              Height = 15
              Caption = 'Viscosity (SEAWAT)'
            end
            object lblGwmSTAVAR: TLabel
              Left = 8
              Top = 288
              Width = 114
              Height = 15
              Caption = 'GWM State Variables'
            end
            object lblCCBD: TLabel
              Left = 8
              Top = 146
              Width = 185
              Height = 15
              Caption = 'Constant-Concentration Boundary'
            end
            object lbl1VBAL: TLabel
              Left = 8
              Top = 160
              Width = 141
              Height = 15
              Caption = 'Volume Balancing Package'
            end
            object cbPESExport: TCheckBox
              Left = 208
              Top = 32
              Width = 44
              Height = 17
              Caption = 'PES'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 1
            end
            object cbCONC: TCheckBox
              Left = 208
              Top = 48
              Width = 52
              Height = 17
              HelpContext = 11060
              Caption = 'CONC'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 2
            end
            object cbOBS: TCheckBox
              Left = 208
              Top = 64
              Width = 52
              Height = 17
              HelpContext = 11060
              Caption = 'OBS'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 3
            end
            object cbExpIPDA: TCheckBox
              Left = 208
              Top = 80
              Width = 52
              Height = 17
              HelpContext = 11060
              Caption = 'IPDA'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 4
            end
            object cbExpBFLX: TCheckBox
              Left = 208
              Top = 96
              Width = 52
              Height = 17
              HelpContext = 11060
              Caption = 'BFLX'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 5
            end
            object cbExpCBDY: TCheckBox
              Left = 208
              Top = 112
              Width = 52
              Height = 17
              HelpContext = 11060
              Caption = 'CBDY'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 6
            end
            object cbFTI: TCheckBox
              Left = 208
              Top = 176
              Width = 52
              Height = 17
              HelpContext = 11060
              Caption = 'FTI'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 10
            end
            object cbGWM_DECVAR: TCheckBox
              Left = 208
              Top = 192
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'DECVAR'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 11
            end
            object cbGWM_OBJFNC: TCheckBox
              Left = 208
              Top = 208
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'OBJFNC'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 12
            end
            object cbGWM_VARCON: TCheckBox
              Left = 208
              Top = 224
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'VARCON'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 13
            end
            object cbGWM_SUMCON: TCheckBox
              Left = 208
              Top = 240
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'SUMCON'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 14
            end
            object cbGWM_HEDCON: TCheckBox
              Left = 208
              Top = 256
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'HEDCON'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 15
            end
            object cbGWM_STRMCON: TCheckBox
              Left = 208
              Top = 272
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'STRMCON'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 16
            end
            object cbGWM_SOLN: TCheckBox
              Left = 208
              Top = 304
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'SOLN'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 18
            end
            object cbExpPTOB: TCheckBox
              Left = 208
              Top = 128
              Width = 65
              Height = 12
              HelpContext = 11060
              Caption = 'PTOB'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 7
            end
            object cbExpUZF: TCheckBox
              Left = 208
              Top = 318
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'UZF'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 19
            end
            object cbSEN: TCheckBox
              Left = 208
              Top = 16
              Width = 52
              Height = 17
              HelpContext = 11060
              Caption = 'SEN'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 0
            end
            object cbExpVsc: TCheckBox
              Left = 208
              Top = 334
              Width = 89
              Height = 17
              HelpContext = 11060
              Caption = 'VSC'
              Checked = True
              Enabled = False
              State = cbChecked
              TabOrder = 20
            end
            object cbGWM_STAVAR: TCheckBox
              Left = 208
              Top = 288
              Width = 97
              Height = 17
              Caption = 'STAVAR'
              TabOrder = 17
            end
            object cbExpCCBD: TCheckBox
              Left = 208
              Top = 144
              Width = 60
              Height = 17
              Caption = 'CCBD'
              Checked = True
              State = cbChecked
              TabOrder = 8
            end
            object cbExpVBAL: TCheckBox
              Left = 208
              Top = 160
              Width = 60
              Height = 17
              Caption = 'VBAL'
              Checked = True
              State = cbChecked
              TabOrder = 9
            end
          end
        end
      end
    end
    object tapPath: TTabSheet
      Caption = 'Model Paths'
      ImageIndex = 1
      object lblMODFLOWPath: TLabel
        Left = 4
        Top = 88
        Width = 108
        Height = 15
        Caption = 'MODFLOW-96 Path'
      end
      object lblMOC3DPath: TLabel
        Left = 4
        Top = 128
        Width = 71
        Height = 15
        Caption = 'MOC3D Path'
      end
      object lblZoneBudPath: TLabel
        Left = 4
        Top = 288
        Width = 153
        Height = 15
        Caption = 'ZONEBDGT (Version 3) Path'
      end
      object lblMODPATH: TLabel
        Left = 4
        Top = 208
        Width = 247
        Height = 15
        Caption = 'MODPATH 3.2 Path (use with MODFLOW-96)'
      end
      object lblModflow2000Path: TLabel
        Left = 4
        Top = 48
        Width = 120
        Height = 15
        Caption = 'MODFLOW 2000 Path'
      end
      object lblResanPath: TLabel
        Left = 4
        Top = 328
        Width = 96
        Height = 15
        Caption = 'RESAN-2000 Path'
      end
      object lblYcintPath: TLabel
        Left = 4
        Top = 368
        Width = 91
        Height = 15
        Caption = 'YCINT-2000 Path'
      end
      object lblBealePath: TLabel
        Left = 4
        Top = 408
        Width = 94
        Height = 15
        Caption = 'BEALE-2000 Path'
      end
      object lblMODPATH41: TLabel
        Left = 4
        Top = 248
        Width = 309
        Height = 15
        Caption = 'MODPATH 5.0 Path (use with MODFLOW-2000 and 2005)'
      end
      object lblMF2K_GWTPath: TLabel
        Left = 4
        Top = 168
        Width = 70
        Height = 15
        Caption = 'MF2K_GWT'
      end
      object lblMT3DPath: TLabel
        Left = 4
        Top = 448
        Width = 81
        Height = 15
        Caption = 'MT3DMS Path'
      end
      object ASLinkMF2K: TASLink
        Left = 176
        Top = 48
        Width = 379
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 
          'http://water.usgs.gov/nrp/gwsoftware/modflow2000/modflow2000.htm' +
          'l'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkmf96: TASLink
        Left = 176
        Top = 88
        Width = 259
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://water.usgs.gov/software/modflow-96.html'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkMOC3D: TASLink
        Left = 176
        Top = 128
        Width = 309
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://water.usgs.gov/nrp/gwsoftware/moc3d/moc3d.html'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkMf2kGWT: TASLink
        Left = 176
        Top = 168
        Width = 343
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://water.usgs.gov/nrp/gwsoftware/mf2k_gwt/mf2k_gwt.html'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkMpath3: TASLink
        Left = 272
        Top = 208
        Width = 244
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://water.usgs.gov/software/modpath.html'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkMpath4: TASLink
        Left = 322
        Top = 247
        Width = 345
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://water.usgs.gov/nrp/gwsoftware/modpath5/modpath5.html'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkZonebudget: TASLink
        Left = 176
        Top = 288
        Width = 360
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://water.usgs.gov/nrp/gwsoftware/zonebud3/zonebudget3.html'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkResan: TASLink
        Left = 176
        Top = 328
        Width = 379
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 
          'http://water.usgs.gov/nrp/gwsoftware/modflow2000/modflow2000.htm' +
          'l'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkYcint: TASLink
        Left = 176
        Top = 368
        Width = 379
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 
          'http://water.usgs.gov/nrp/gwsoftware/modflow2000/modflow2000.htm' +
          'l'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkBeale: TASLink
        Left = 176
        Top = 408
        Width = 379
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 
          'http://water.usgs.gov/nrp/gwsoftware/modflow2000/modflow2000.htm' +
          'l'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkMT3D: TASLink
        Left = 176
        Top = 448
        Width = 164
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://hydro.geo.ua.edu/mt3d/'
        URLTypeAdd = False
        URLType = utHttp
      end
      object ASLinkSeaWat: TASLink
        Left = 176
        Top = 488
        Width = 189
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://water.usgs.gov/ogw/seawat/'
        URLTypeAdd = False
        URLType = utHttp
      end
      object lblSeaWatPath: TLabel
        Left = 4
        Top = 488
        Width = 131
        Height = 15
        Caption = 'SEAWAT version 4 Path'
      end
      object lblGWM_Path: TLabel
        Left = 4
        Top = 528
        Width = 88
        Height = 15
        Caption = 'GWM-2005 Path'
      end
      object ASLinkGWM: TASLink
        Left = 176
        Top = 528
        Width = 388
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 'http://water.usgs.gov/nrp/gwsoftware/mf2005_gwm/MF2005-GWM.html'
        URLTypeAdd = False
        URLType = utHttp
      end
      object lblModflow2005Path: TLabel
        Left = 4
        Top = 8
        Width = 120
        Height = 15
        Caption = 'MODFLOW 2005 Path'
      end
      object ASLinkMF2005: TASLink
        Left = 176
        Top = 8
        Width = 379
        Height = 16
        Cursor = crHandPoint
        Transparent = True
        Caption = 
          'http://water.usgs.gov/nrp/gwsoftware/modflow2005/modflow2005.htm' +
          'l'
        URLTypeAdd = False
        URLType = utHttp
      end
      object adeMODFLOWPath: TArgusDataEntry
        Left = 4
        Top = 104
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 4
        Text = 'C:\Modflw96.3_3\bin\Modflw96.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeMOC3DPath: TArgusDataEntry
        Left = 4
        Top = 144
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 6
        Text = 'C:\MOC3D3.5\bin\moc3d.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnMODFLOWBrowse: TButton
        Left = 443
        Top = 104
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 5
        OnClick = BrowseClick
      end
      object btnMOC3DBrowse: TButton
        Left = 443
        Top = 144
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 7
        OnClick = BrowseClick
      end
      object adeZonebudgetPath: TArgusDataEntry
        Left = 4
        Top = 304
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 14
        Text = 'C:\ZONBUD.2_1\BIN\zonbud.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnZonebudget: TButton
        Left = 443
        Top = 304
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 15
        OnClick = BrowseClick
      end
      object adeMODPATHPath: TArgusDataEntry
        Left = 4
        Top = 224
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 10
        Text = 'C:\Program Files\USGS\mpath3.2\bin\MPATH3L.EXE'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnMODPATH: TButton
        Left = 443
        Top = 224
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 11
        OnClick = BrowseClick
      end
      object adeModflow2000Path: TArgusDataEntry
        Left = 4
        Top = 64
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 2
        Text = 'C:\MF2K.1_10\BIN\mf2k.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnModflow2000: TButton
        Left = 443
        Top = 64
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 3
        OnClick = BrowseClick
      end
      object adeResanPath: TArgusDataEntry
        Left = 4
        Top = 344
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 16
        Text = 'C:\MF2K.1_8\BIN\resan2k.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnResan: TButton
        Left = 443
        Top = 344
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 17
        OnClick = BrowseClick
      end
      object adeYcintPath: TArgusDataEntry
        Left = 4
        Top = 384
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 18
        Text = 'C:\MF2K.1_8\BIN\ycint2k.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnYcintPath: TButton
        Left = 443
        Top = 384
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 19
        OnClick = BrowseClick
      end
      object adeBealePath: TArgusDataEntry
        Left = 4
        Top = 424
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 20
        Text = 'C:\MF2K.1_8\BIN\beale2k.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnBealePath: TButton
        Left = 443
        Top = 424
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 21
        OnClick = BrowseClick
      end
      object adeMODPATH41Path: TArgusDataEntry
        Left = 4
        Top = 264
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 12
        Text = 'C:\WRDAPP\MPATH.4_3\SETUP\Mpathr4_3.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnMODPATH41: TButton
        Left = 443
        Top = 264
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 13
        OnClick = BrowseClick
      end
      object adeMF2K_GWTPath: TArgusDataEntry
        Left = 4
        Top = 184
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 8
        Text = 'C:\mf2k_gwt\bin\mf2k_gwt.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnMF2K_GWTBrowse: TButton
        Left = 443
        Top = 184
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 9
        OnClick = BrowseClick
      end
      object adeMT3DPath: TArgusDataEntry
        Left = 4
        Top = 464
        Width = 429
        Height = 22
        ItemHeight = 15
        TabOrder = 23
        Text = 'C:\MT3DMS\mt3dms4.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnMT3D: TButton
        Left = 443
        Top = 463
        Width = 50
        Height = 25
        Caption = 'Browse'
        TabOrder = 22
        OnClick = BrowseClick
      end
      object adeSEAWAT: TArgusDataEntry
        Left = 4
        Top = 504
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 24
        Text = 'C:\swt2k_v3_10\exe\swt2k.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnSEAWAT: TButton
        Left = 443
        Top = 504
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 25
        OnClick = BrowseClick
      end
      object adeGWM: TArgusDataEntry
        Left = 4
        Top = 544
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 26
        Text = 'C:\WRDAPP\GWM2005.1_3_1\bin\gwm2005.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnGWM: TButton
        Left = 443
        Top = 544
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 27
        OnClick = BrowseClick
      end
      object adeModflow2005: TArgusDataEntry
        Left = 4
        Top = 24
        Width = 429
        Height = 22
        HelpContext = 11070
        ItemHeight = 15
        TabOrder = 0
        Text = 'C:\MF2005.1_2\Bin\mf2005.exe'
        OnChange = adeModelPathChange
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object btnModflow2005: TButton
        Left = 443
        Top = 24
        Width = 50
        Height = 25
        HelpContext = 11070
        Caption = 'Browse'
        TabOrder = 1
        OnClick = BrowseClick
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 657
    Width = 772
    Height = 37
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      772
      37)
    object lblWarning2: TLabel
      Left = 8
      Top = 0
      Width = 326
      Height = 30
      Caption = 
        'Warning: Be sure to turn OFF "Special|Manual Calculation" before' +
        ' attempting to export data.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object btnEdit: TButton
      Left = 379
      Top = 6
      Width = 96
      Height = 25
      HelpContext = 11080
      Anchors = [akTop, akRight]
      Caption = 'Edit Project Info'
      TabOrder = 0
      OnClick = btnEditClick
    end
    object btOK: TBitBtn
      Left = 674
      Top = 6
      Width = 89
      Height = 25
      HelpContext = 11090
      Anchors = [akTop, akRight]
      Caption = '&OK'
      TabOrder = 3
      OnClick = btOKClick
      Kind = bkOK
    end
    object btnCancel: TBitBtn
      Left = 578
      Top = 6
      Width = 89
      Height = 25
      HelpContext = 11100
      Anchors = [akTop, akRight]
      TabOrder = 2
      Kind = bkCancel
    end
    object btnHelp: TBitBtn
      Left = 482
      Top = 6
      Width = 89
      Height = 25
      HelpContext = 11040
      Anchors = [akTop, akRight]
      Caption = 'Help'
      TabOrder = 1
      Kind = bkHelp
    end
  end
  object opendialGetPath: TOpenDialog
    Filter = 'Executable files (*.exe, *.bat)|*.exe;*.bat|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 176
    Top = 8
  end
  object savedlgExportFiles: TSaveDialog
    DefaultExt = 'nam'
    Filter = 'Name Files (*.nam)|*.nam|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing]
    Left = 208
    Top = 16
  end
end
