object HST3DForm: THST3DForm
  Left = 325
  Top = 165
  Caption = 'HST3D 2.0'
  ClientHeight = 426
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseMove = FormMouseMove
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 14
  object TLabel
    Left = 256
    Top = 234
    Width = 216
    Height = 14
    Caption = 'Number of Heat Conduction Boundary Nodes'
    Enabled = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 606
    Height = 384
    ActivePage = tabSolver
    Align = alClient
    MultiLine = True
    TabOrder = 0
    OnChange = FormResize
    ExplicitWidth = 616
    ExplicitHeight = 402
    object tabAbout: TTabSheet
      Caption = 'About'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label21: TLabel
        Left = 171
        Top = 16
        Width = 175
        Height = 14
        Caption = 'HST3D 2.0 Graphical User Interface,'
      end
      object lblDevName: TLabel
        Left = 22
        Top = 120
        Width = 92
        Height = 14
        Caption = 'Richard B. Winston'
      end
      object Label26: TLabel
        Left = 22
        Top = 88
        Width = 96
        Height = 14
        Caption = 'Contact information:'
      end
      object lblAdress: TLabel
        Left = 22
        Top = 136
        Width = 91
        Height = 14
        Caption = '2145 Colts Neck Ct'
      end
      object lblCity: TLabel
        Left = 22
        Top = 152
        Width = 114
        Height = 14
        Caption = 'Reston, Va 20191-1841'
      end
      object lblTelephone: TLabel
        Left = 22
        Top = 184
        Width = 74
        Height = 14
        Caption = '(703) 476 8281'
      end
      object lblVersion: TLabel
        Left = 222
        Top = 44
        Width = 37
        Height = 14
        Caption = 'Version'
      end
      object Label6: TLabel
        Left = 22
        Top = 64
        Width = 235
        Height = 14
        Caption = 'Only Cartesian coordinates supported at present'
      end
      object Label23: TLabel
        Left = 22
        Top = 304
        Width = 103
        Height = 14
        Caption = 'Copyright: 1998,1999'
      end
      object Label24: TLabel
        Left = 22
        Top = 168
        Width = 22
        Height = 14
        Caption = 'USA'
      end
      object ASLinkWinston: TASLink
        Left = 22
        Top = 200
        Width = 129
        Height = 14
        Cursor = crHandPoint
        ShadowSize = 0
        Transparent = True
        Caption = 'hst3dgui@mindspring.com'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        PopupMenu = PopupMenu1
        OnClick = ASLinkWinstonClick
      end
      object lblIntDev: TLabel
        Left = 22
        Top = 104
        Width = 126
        Height = 14
        Caption = 'HT3D Interface developer:'
      end
      object Label35: TLabel
        Left = 232
        Top = 88
        Width = 88
        Height = 14
        Caption = 'HST3D Developer:'
      end
      object Label36: TLabel
        Left = 232
        Top = 104
        Width = 76
        Height = 14
        Caption = 'Kenneth L. Kipp'
      end
      object Label37: TLabel
        Left = 232
        Top = 120
        Width = 64
        Height = 14
        Caption = 'Mail Stop 413'
      end
      object Label38: TLabel
        Left = 232
        Top = 136
        Width = 109
        Height = 14
        Caption = 'Denver Federal Center'
      end
      object Label39: TLabel
        Left = 232
        Top = 152
        Width = 91
        Height = 14
        Caption = 'Denver, CO, 80225'
      end
      object Label40: TLabel
        Left = 232
        Top = 168
        Width = 22
        Height = 14
        Caption = 'USA'
      end
      object Label41: TLabel
        Left = 232
        Top = 184
        Width = 68
        Height = 14
        Caption = '303-236-4991'
      end
      object ASLinkKipp: TASLink
        Left = 232
        Top = 200
        Width = 84
        Height = 14
        Cursor = crHandPoint
        ShadowSize = 0
        Transparent = True
        Caption = 'klkipp@usgs.gov'
        Color = clBlue
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        PopupMenu = PopupMenu1
        OnClick = ASLinkKippClick
      end
      object ASLinkFAQ: TASLink
        Left = 22
        Top = 248
        Width = 310
        Height = 14
        Cursor = crHandPoint
        ShadowSize = 0
        Transparent = True
        Caption = 'http://www.mindspring.com/~rbwinston/hst3dgui/hst3d_faq.htm'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        URLTypeAdd = False
        URLType = utHttp
      end
      object lblGuiFaq: TLabel
        Left = 22
        Top = 232
        Width = 98
        Height = 14
        Caption = 'The HST3D GUI FAQ'
      end
      object Label43: TLabel
        Left = 22
        Top = 272
        Width = 110
        Height = 14
        Caption = 'USGS HST3D web site'
      end
      object ASLink2: TASLink
        Left = 22
        Top = 288
        Width = 306
        Height = 14
        Cursor = crHandPoint
        ShadowSize = 0
        Transparent = True
        Caption = 'http://wwwbrr.cr.usgs.gov/projects/GW_Solute/hst/index.shtml'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        URLTypeAdd = False
        URLType = utHttp
      end
      object EdVersion: TEdit
        Left = 254
        Top = 36
        Width = 33
        Height = 22
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        Text = '1.73'
        Visible = False
      end
    end
    object tabProblem: TTabSheet
      Caption = 'Unread Data'
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object memoUnreadData: TMemo
        Left = 0
        Top = 0
        Width = 608
        Height = 335
        Align = alClient
        PopupMenu = PopupMenu1
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tabProject: TTabSheet
      Caption = 'Project'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblTime: TLabel
        Left = 96
        Top = 296
        Width = 107
        Height = 14
        Caption = 'Restart Time (TIMRST)'
        Enabled = False
      end
      object lblThetxz: TLabel
        Left = 360
        Top = 104
        Width = 158
        Height = 28
        Caption = 'Angle of X-axis with the vertical (THETXZ) (Degrees)'
        Enabled = False
        WordWrap = True
      end
      object lblThetyz: TLabel
        Left = 360
        Top = 168
        Width = 158
        Height = 28
        Caption = 'Angle of Y-axis with the vertical (THETYZ) (Degrees)'
        Enabled = False
        WordWrap = True
      end
      object lblThetzz: TLabel
        Left = 360
        Top = 240
        Width = 158
        Height = 28
        Caption = 'Angle of Z-axis with the vertical (THETZZ) (Degrees)'
        Enabled = False
        WordWrap = True
      end
      object Label11: TLabel
        Left = 8
        Top = 8
        Width = 84
        Height = 14
        Caption = 'HST3D Title Lines'
      end
      object edTitleLine1: TEdit
        Left = 8
        Top = 24
        Width = 497
        Height = 22
        Hint = '1.1 Title line 1'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        Text = 'Title Line 1'
        OnChange = edTitleLinesChange
      end
      object edTitleLine2: TEdit
        Left = 8
        Top = 48
        Width = 497
        Height = 22
        Hint = '1.2 Title line 2'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
        Text = 'Title Line 2'
        OnChange = edTitleLinesChange
      end
      object cbRestart: TCheckBox
        Left = 8
        Top = 264
        Width = 201
        Height = 17
        Hint = '1.3 RESTRT'
        Caption = 'Restart previous simulation (RESTRT)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 11
        OnClick = cbRestartClick
      end
      object rgUnits: TRadioGroup
        Left = 8
        Top = 80
        Width = 177
        Height = 57
        Hint = '1.4 EEUNIT'
        Caption = 'Units (EEUNIT)'
        ItemIndex = 0
        Items.Strings = (
          'Metric units'
          'U.S. customary units')
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
        OnClick = rgUnitsClick
      end
      object rgTimeUnits: TRadioGroup
        Left = 8
        Top = 152
        Width = 177
        Height = 73
        Hint = '1.5 TMUNIT'
        Caption = 'Time Units (TMUNIT)'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'seconds'
          'minutes'
          'hours'
          'days'
          'years')
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 6
      end
      object cbTiltCoord: TCheckBox
        Left = 352
        Top = 80
        Width = 169
        Height = 17
        Hint = '2.3.1 TILT'
        Caption = 'Tilted Coordinate System (TILT)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 4
        OnClick = cbTiltCoordClick
      end
      object adeTime: TArgusDataEntry
        Left = 8
        Top = 288
        Width = 81
        Height = 22
        Hint = '1.3 TIMRST'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 13
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeThetxz: TArgusDataEntry
        Left = 360
        Top = 136
        Width = 161
        Height = 22
        Hint = '2.3.2 THETXZ'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 5
        Text = '90'
        OnExit = adeThetExit
        DataType = dtReal
        Max = 90.000000000000000000
        CheckMax = True
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeThetyz: TArgusDataEntry
        Left = 360
        Top = 200
        Width = 161
        Height = 22
        Hint = '2.3.2 THETYZ'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 8
        Text = '90'
        OnExit = adeThetExit
        DataType = dtReal
        Max = 90.000000000000000000
        CheckMax = True
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeThetzz: TArgusDataEntry
        Left = 360
        Top = 272
        Width = 161
        Height = 22
        Hint = '2.3.2 THETZZ'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 12
        Text = '0'
        OnExit = adeThetExit
        DataType = dtReal
        Max = 90.000000000000000000
        CheckMax = True
        CheckMin = True
        ChangeDisabledColor = True
      end
      object rgCoord: TRadioGroup
        Left = 192
        Top = 80
        Width = 153
        Height = 57
        Hint = '1.4 CYLIND'
        Caption = 'Coordinate System (CYLIND)'
        Enabled = False
        ItemIndex = 0
        Items.Strings = (
          'Cartesian'
          'Cylindrical')
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        OnClick = rgCoordClick
      end
      object rgMassFrac: TRadioGroup
        Left = 192
        Top = 152
        Width = 153
        Height = 73
        Hint = '1.4 SCALMF'
        Caption = 'Mass Fraction (SCALMF)'
        ItemIndex = 1
        Items.Strings = (
          'Unscaled mass fraction'
          'Scaled mass fraction')
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 7
        OnClick = rgMassFracClick
      end
      object rgAngleChoice: TRadioGroup
        Left = 224
        Top = 248
        Width = 121
        Height = 73
        Caption = 'Dependent Angle'
        Enabled = False
        ItemIndex = 2
        Items.Strings = (
          'THETXZ'
          'THETYZ'
          'THETZZ')
        PopupMenu = PopupMenu1
        TabOrder = 10
        OnClick = rgAngleChoiceClick
      end
      object cbObsElev: TCheckBox
        Left = 8
        Top = 240
        Width = 201
        Height = 17
        Caption = 'Use Observation Elevations'
        TabOrder = 9
        OnClick = cbObsElevClick
      end
    end
    object tabGeology: TTabSheet
      Caption = 'Elements'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sgGeology: TStringGrid
        Left = 0
        Top = 0
        Width = 608
        Height = 310
        Align = alClient
        ColCount = 4
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        OnDrawCell = sgGeologyDrawCell
        OnExit = sgGeologyExit
        OnSelectCell = sgGeologySelectCell
        OnSetEditText = sgGeologySetEditText
        ColWidths = (
          134
          181
          128
          131)
      end
      object Panel4: TPanel
        Left = 0
        Top = 310
        Width = 608
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object lblNumLayers: TLabel
          Left = 328
          Top = 20
          Width = 127
          Height = 14
          Caption = 'Number of Element Layers'
        end
        object btnAddLayer: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Add Layer'
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnClick = btnAddLayerClick
        end
        object btnDeleteLayer: TButton
          Left = 88
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Delete Layer'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 1
          OnClick = btnDeleteLayerClick
        end
        object btnInsertLayer: TButton
          Left = 168
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Insert Layer'
          PopupMenu = PopupMenu1
          TabOrder = 2
          OnClick = btnInsertLayerClick
        end
        object edNumLayers: TEdit
          Left = 248
          Top = 12
          Width = 73
          Height = 22
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 3
          Text = '1'
          OnChange = edNumLayersChange
        end
      end
    end
    object tabBound: TTabSheet
      Caption = 'Processes/Boundary'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 608
        Height = 73
        Align = alTop
        Caption = 'Processes'
        TabOrder = 0
        object cbHeat: TCheckBox
          Left = 16
          Top = 16
          Width = 177
          Height = 17
          Hint = '1.4 HEAT'
          Caption = 'Heat transport simulated (HEAT)'
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 0
          OnClick = cbHeatClick
        end
        object cbSolute: TCheckBox
          Left = 16
          Top = 32
          Width = 201
          Height = 17
          Hint = '1.4 SOLUTE'
          Caption = 'Solute transport simulated (SOLUTE)'
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 1
          OnClick = cbSoluteClick
        end
        object cbFreeSurf: TCheckBox
          Left = 16
          Top = 48
          Width = 145
          Height = 17
          Hint = '2.20 FRESUR'
          Caption = 'Free surface (FRESUR)'
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 2
          OnClick = cbFreeSurfClick
        end
        object cbHeatInterpInit: TCheckBox
          Left = 224
          Top = 16
          Width = 313
          Height = 17
          Caption = 'Allow interpolation along open contours for initial conditions'
          Enabled = False
          TabOrder = 3
          Visible = False
        end
        object cbSoluteInterpInitial: TCheckBox
          Left = 224
          Top = 32
          Width = 313
          Height = 17
          Caption = 'Allow interpolation along open contours for initial conditions'
          Enabled = False
          TabOrder = 4
          Visible = False
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 73
        Width = 608
        Height = 277
        Align = alClient
        Caption = 'Boundary Conditions'
        TabOrder = 1
        object cbSpecPres: TCheckBox
          Left = 16
          Top = 16
          Width = 121
          Height = 17
          Caption = 'Specified pressure'
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnClick = cbSpecPresClick
        end
        object cbSpecTemp: TCheckBox
          Left = 16
          Top = 32
          Width = 129
          Height = 17
          Caption = 'Specified temperature'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 2
          OnClick = cbSpecPresClick
        end
        object cbSpecMass: TCheckBox
          Left = 16
          Top = 48
          Width = 145
          Height = 17
          Caption = 'Specified mass fraction'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 4
          OnClick = cbSpecPresClick
        end
        object cbSpecFlow: TCheckBox
          Left = 16
          Top = 64
          Width = 145
          Height = 17
          Caption = 'Specified fluid flux'
          PopupMenu = PopupMenu1
          TabOrder = 6
          OnClick = cbSpecFlowClick
        end
        object cbSpecHeat: TCheckBox
          Left = 16
          Top = 80
          Width = 129
          Height = 17
          Caption = 'Specified heat flux'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 8
          OnClick = cbSpecFlowClick
        end
        object cbSpecSolute: TCheckBox
          Left = 16
          Top = 96
          Width = 121
          Height = 17
          Caption = 'Specified solute flux'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 10
          OnClick = cbSpecFlowClick
        end
        object cbLeakage: TCheckBox
          Left = 16
          Top = 112
          Width = 121
          Height = 17
          Caption = 'Leakage boundary'
          PopupMenu = PopupMenu1
          TabOrder = 12
          OnClick = cbLeakageClick
        end
        object cbET: TCheckBox
          Left = 16
          Top = 144
          Width = 169
          Height = 17
          Caption = 'Evapotranspiration boundary'
          PopupMenu = PopupMenu1
          TabOrder = 16
          OnClick = cbETClick
        end
        object cbAqInfl: TCheckBox
          Left = 16
          Top = 160
          Width = 153
          Height = 17
          Caption = 'Aquifer influence boundary'
          PopupMenu = PopupMenu1
          TabOrder = 18
          OnClick = cbAqInflClick
        end
        object cbHeatCond: TCheckBox
          Left = 16
          Top = 176
          Width = 153
          Height = 17
          Caption = 'Heat conduction boundary'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 20
          OnClick = cbHeatCondClick
        end
        object cbWells: TCheckBox
          Left = 16
          Top = 192
          Width = 97
          Height = 17
          Caption = 'Wells'
          PopupMenu = PopupMenu1
          TabOrder = 22
          OnClick = cbWellsClick
        end
        object cbRiver: TCheckBox
          Left = 16
          Top = 128
          Width = 97
          Height = 17
          Caption = 'River leakage'
          PopupMenu = PopupMenu1
          TabOrder = 14
          OnClick = cbRiverClick
        end
        object cbWellRiser: TCheckBox
          Left = 16
          Top = 208
          Width = 177
          Height = 17
          Caption = 'Perform well riser calculations'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 23
          OnClick = cbWellRiserClick
        end
        object cbSpecFlowInterp: TCheckBox
          Left = 192
          Top = 64
          Width = 337
          Height = 17
          Hint = 
            'Note you must select specific parameters on the interpolation ta' +
            'b after selecting this check box.'
          Caption = 'Allow interpolation along open contours for specified fluid flux'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 7
          OnClick = cbSpecFlowInterpClick
        end
        object cbSpecHeatInterp: TCheckBox
          Left = 192
          Top = 80
          Width = 321
          Height = 17
          Caption = 'Allow interpolation along open contours for specified heat flux'
          Enabled = False
          TabOrder = 9
          Visible = False
        end
        object cbSpecSoluteInterp: TCheckBox
          Left = 192
          Top = 96
          Width = 329
          Height = 17
          Caption = 
            'Allow interpolation along open contours for specified solute flu' +
            'x'
          Enabled = False
          TabOrder = 11
          Visible = False
        end
        object cbLeakageInterp: TCheckBox
          Left = 192
          Top = 112
          Width = 321
          Height = 17
          Caption = 'Allow interpolation along open contours for leakage boundary'
          Enabled = False
          TabOrder = 13
          Visible = False
        end
        object cbRiverInterp: TCheckBox
          Left = 192
          Top = 128
          Width = 313
          Height = 17
          Caption = 'Allow interpolation along open contours for river leakage'
          Enabled = False
          TabOrder = 15
          Visible = False
        end
        object cbETInterp: TCheckBox
          Left = 192
          Top = 144
          Width = 377
          Height = 17
          Caption = 
            'Allow interpolation along open contours for evapotranspiration b' +
            'oundary'
          Enabled = False
          TabOrder = 17
          Visible = False
        end
        object cbAqInflInterp: TCheckBox
          Left = 192
          Top = 160
          Width = 369
          Height = 17
          Caption = 
            'Allow interpolation along open contours for aquifer influence bo' +
            'undary'
          Enabled = False
          TabOrder = 19
          Visible = False
        end
        object cbHeatCondInterp: TCheckBox
          Left = 192
          Top = 176
          Width = 385
          Height = 17
          Caption = 
            'Allow interpolation along open contours for heat conduction boun' +
            'dary'
          Enabled = False
          TabOrder = 21
          Visible = False
        end
        object cbSpecPresInterp: TCheckBox
          Left = 192
          Top = 16
          Width = 393
          Height = 17
          Hint = 
            'Note you must select specific parameters on the interpolation ta' +
            'b after selecting this check box.'
          Caption = 
            'Allow interpolation along open contours for specified pressure p' +
            'arameters'
          Enabled = False
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 1
          OnClick = cbSpecPresInterpClick
        end
        object cbSpecTempInterp: TCheckBox
          Left = 192
          Top = 32
          Width = 369
          Height = 17
          Caption = 
            'Allow interpolation along open contours for specified temperatur' +
            'e'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 3
          OnClick = cbSpecTempInterpClick
        end
        object cbSpecMassInterp: TCheckBox
          Left = 192
          Top = 48
          Width = 393
          Height = 17
          Caption = 
            'Allow interpolation along open contours for specified mass fract' +
            'ion'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 5
          OnClick = cbSpecMassInterpClick
        end
      end
    end
    object tabInterpolation: TTabSheet
      Caption = 'Interpolation'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblInterpAqLeak: TLabel
        Left = 328
        Top = 136
        Width = 128
        Height = 14
        Caption = 'Interpolate Aquifer leakage'
        Enabled = False
        Visible = False
      end
      object lblInterpRiver: TLabel
        Left = 160
        Top = 136
        Width = 78
        Height = 14
        Caption = 'Interpolate River'
        Enabled = False
        Visible = False
      end
      object lblInterpAqInfl: TLabel
        Left = 416
        Top = 8
        Width = 135
        Height = 14
        Caption = 'Interpolate Aquifer Influence'
        Enabled = False
        Visible = False
      end
      object lblInterpET: TLabel
        Left = 200
        Top = 8
        Width = 143
        Height = 14
        Caption = 'Interpolate Evapotranspiration'
        Enabled = False
        Visible = False
      end
      object lblInterpHeatCond: TLabel
        Left = 8
        Top = 240
        Width = 132
        Height = 14
        Caption = 'Interpolate Heat Conduction'
        Enabled = False
        Visible = False
      end
      object gbInterpSpecPres: TGroupBox
        Left = 8
        Top = 8
        Width = 185
        Height = 97
        Caption = 'Interpolate Specified Pressure'
        TabOrder = 0
        object cbInterpSpecPres: TCheckBox
          Left = 8
          Top = 16
          Width = 169
          Height = 17
          Caption = 'Specified pressure'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnClick = cbInterpSpecPresClick
        end
        object cbInterpTempSpecPres: TCheckBox
          Left = 8
          Top = 32
          Width = 169
          Height = 17
          Caption = 'Temp at Spec Pres'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 1
          OnClick = cbInterpTempSpecPresClick
        end
        object cbInterpMassSpecPress: TCheckBox
          Left = 8
          Top = 48
          Width = 169
          Height = 17
          Caption = 'Mass Frac at Spec Pres'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 2
          OnClick = cbInterpMassSpecPressClick
        end
        object cbInterpScMassFracSpecPres: TCheckBox
          Left = 8
          Top = 64
          Width = 171
          Height = 17
          Caption = 'Scaled Mass Frac at Spec Pres'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 3
          OnClick = cbInterpScMassFracSpecPresClick
        end
      end
      object gbInterpSpecFlux: TGroupBox
        Left = 8
        Top = 136
        Width = 137
        Height = 105
        Caption = 'Interpolate Fluid Flux'
        Enabled = False
        TabOrder = 1
        object cbFluidFluxInterp: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Fluid Flux'
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnClick = cbFluidFluxInterpClick
        end
        object cbFluxDensityInterp: TCheckBox
          Left = 8
          Top = 32
          Width = 97
          Height = 17
          Caption = 'Fluid Density'
          PopupMenu = PopupMenu1
          TabOrder = 1
          OnClick = cbFluxDensityInterpClick
        end
        object cbFluxTempInterp: TCheckBox
          Left = 8
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Temperature'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 2
          OnClick = cbFluxTempInterpClick
        end
        object cbFluxScMassFracInterp: TCheckBox
          Left = 8
          Top = 80
          Width = 121
          Height = 17
          Caption = 'Scaled Mass Fraction'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 3
          OnClick = cbFluxScMassFracInterpClick
        end
        object cbFluxMassFracInterp: TCheckBox
          Left = 8
          Top = 64
          Width = 97
          Height = 17
          Caption = 'Mass Fraction'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 4
          OnClick = cbFluxMassFracInterpClick
        end
      end
    end
    object tabFluidProp: TTabSheet
      Caption = 'Fluid Properties'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 160
        Top = 64
        Width = 247
        Height = 14
        Caption = 'Reference temperature for density (T0) (T) (C or F)'
      end
      object Label4: TLabel
        Left = 160
        Top = 88
        Width = 392
        Height = 14
        Caption = 
          'Reference mass fraction for density and minimum fraction for sca' +
          'ling (WO) (M/M)'
      end
      object lblMaxMassFrac: TLabel
        Left = 160
        Top = 136
        Width = 225
        Height = 14
        Caption = 'Maximum-mass fraction for scaling (W1) (M/M)'
        Enabled = False
      end
      object lblVisMultFact: TLabel
        Left = 160
        Top = 184
        Width = 188
        Height = 14
        Caption = 'Viscosity Multiplication factor (VISFAC)'
      end
      object lblViscosity: TLabel
        Left = 160
        Top = 208
        Width = 187
        Height = 14
        Caption = 'Viscosity (VISFAC) (M/Lt) (Pa-s or cP0'
        Enabled = False
      end
      object lblFluidDenseMax: TLabel
        Left = 160
        Top = 160
        Width = 409
        Height = 14
        Caption = 
          'Fluid density at the maximum solute mass fraction (DENF1) (M/L^3' +
          ') (kg/m^3 or lb/ft^3)'
        Enabled = False
      end
      object Label5: TLabel
        Left = 160
        Top = 40
        Width = 266
        Height = 14
        Caption = 'Reference pressure for density (P0) (F/L^2) (Pa or psi)'
      end
      object Label8: TLabel
        Left = 160
        Top = 16
        Width = 291
        Height = 14
        Caption = 'Compressibility of the fluid (BP) ([F/L^2]^-1) (Pa^-1 or psi^-1)'
      end
      object Label9: TLabel
        Left = 160
        Top = 112
        Width = 346
        Height = 14
        Caption = 
          'Fluid density at reference conditions (DNEF0) (M/L^3) (kg/m^3 or' +
          ' lb/ft^3)'
      end
      object adeCompress: TArgusDataEntry
        Left = 8
        Top = 8
        Width = 145
        Height = 22
        Hint = '2.4.1 BP'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        Text = '4.4e-10'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeRefPres: TArgusDataEntry
        Left = 8
        Top = 32
        Width = 145
        Height = 22
        Hint = '2.4.2 P0'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeRefTemp: TArgusDataEntry
        Left = 8
        Top = 56
        Width = 145
        Height = 22
        Hint = '2.4.2 T0'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
        Text = '20'
        OnExit = adeRefTempExit
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeRefMassFrac: TArgusDataEntry
        Left = 8
        Top = 80
        Width = 145
        Height = 22
        Hint = '2.4.2 W0'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeFluidDensity: TArgusDataEntry
        Left = 8
        Top = 104
        Width = 145
        Height = 22
        Hint = '2.4.2 DENF0'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 4
        Text = '998.23'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeMaxMassFrac: TArgusDataEntry
        Left = 8
        Top = 128
        Width = 145
        Height = 22
        Hint = '2.4.3 W1'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 5
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeFluidDenseMax: TArgusDataEntry
        Left = 8
        Top = 152
        Width = 145
        Height = 22
        Hint = '2.4.3 DENF1'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 6
        Text = '998.23'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeVisMultFact: TArgusDataEntry
        Left = 8
        Top = 176
        Width = 145
        Height = 22
        Hint = '2.4.4 VISFAC if VISFAC is positive'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 7
        Text = '1'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeViscosity: TArgusDataEntry
        Left = 8
        Top = 200
        Width = 145
        Height = 22
        Hint = '2.4.4 VISFAC if VISFAC is negative'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 8
        Text = '0.001002'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object rgViscMeth: TRadioGroup
        Left = 352
        Top = 176
        Width = 209
        Height = 49
        Hint = '2.4.4 determines whether VISFAC is positive or negative'
        Caption = 'Method of specifying viscosity (VISFAC)'
        ItemIndex = 0
        Items.Strings = (
          'Viscosity multiplication factor'
          'Viscosity')
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 9
        OnClick = rgViscMethClick
      end
    end
    object tabRefTherm: TTabSheet
      Caption = 'Ref. Cond./Thermal/Solute Prop.'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label10: TLabel
        Left = 160
        Top = 64
        Width = 310
        Height = 14
        Caption = 'Reference temperature for enthalpy variations (T0H) (T) (C or F)'
      end
      object lblFluidHeatCap: TLabel
        Left = 160
        Top = 88
        Width = 360
        Height = 14
        Caption = 
          'Fluid heat capacity at constant pressure (CPF) (E/MT) (J/kg-C) o' +
          'r BTU/lb-F)'
        Enabled = False
      end
      object lblFluidThermCond: TLabel
        Left = 160
        Top = 112
        Width = 302
        Height = 14
        Caption = 'Fluid thermal conductivity (KTHF) (E/LtT) (W/m-C or BTU/ft-h-F)'
        Enabled = False
      end
      object lblEffMolDiff: TLabel
        Left = 160
        Top = 160
        Width = 361
        Height = 14
        Caption = 
          'Effective molecular diffusivity for the solute in the porous med' +
          'ia (DM) (t^-1)'
        Enabled = False
      end
      object lblSolDecConst: TLabel
        Left = 160
        Top = 184
        Width = 190
        Height = 14
        Caption = 'Solute decay constant (DECLAM) (t^-1)'
        Enabled = False
      end
      object lblFluidCoefExp: TLabel
        Left = 160
        Top = 136
        Width = 303
        Height = 14
        Caption = 
          'Fluid coefficient of thermal expansion (BT) (t^-1) (C^-1 or F^-1' +
          ')'
        Enabled = False
      end
      object Label1: TLabel
        Left = 160
        Top = 16
        Width = 285
        Height = 14
        Caption = 'Atmospheric absolute-pressure (PAATM)(F/L^2) (Pa or psi)'
      end
      object Label2: TLabel
        Left = 160
        Top = 40
        Width = 329
        Height = 14
        Caption = 
          'Reference pressure for enthalpy variations (P0H) (F/L^2) (Pa or ' +
          'psi)'
      end
      object adeAtmPres: TArgusDataEntry
        Left = 8
        Top = 8
        Width = 145
        Height = 22
        Hint = '2.5.1 PAATM'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeRefPresEnth: TArgusDataEntry
        Left = 8
        Top = 32
        Width = 145
        Height = 22
        Hint = '2.5.2 P0H'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeRefTempEnth: TArgusDataEntry
        Left = 8
        Top = 56
        Width = 145
        Height = 22
        Hint = '2.5.2 T0H'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
        Text = '20'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeFluidHeatCap: TArgusDataEntry
        Left = 8
        Top = 80
        Width = 145
        Height = 22
        Hint = '2.6 CPF'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        Text = '4182'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeFluidThermCond: TArgusDataEntry
        Left = 8
        Top = 104
        Width = 145
        Height = 22
        Hint = '2.6 KHTF'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 4
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeFluidCoefExp: TArgusDataEntry
        Left = 8
        Top = 128
        Width = 145
        Height = 22
        Hint = '2.6 BT'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 5
        Text = '2.e-4'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeEffMolDiff: TArgusDataEntry
        Left = 8
        Top = 152
        Width = 145
        Height = 22
        Hint = '2.7 DM'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 6
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeSolDecConst: TArgusDataEntry
        Left = 8
        Top = 176
        Width = 145
        Height = 22
        Hint = '2.7 DECLAM'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 7
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
    end
    object tabWells: TTabSheet
      Caption = 'Wells'
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 105
        Height = 336
        Align = alLeft
        TabOrder = 0
        ExplicitHeight = 354
        object Label31: TLabel
          Left = 8
          Top = 8
          Width = 75
          Height = 28
          Caption = 'Top Completion Elevation'
          WordWrap = True
        end
        object Label32: TLabel
          Left = 8
          Top = 64
          Width = 88
          Height = 28
          Caption = 'Bottom Completion Elevation'
          WordWrap = True
        end
        object Label33: TLabel
          Left = 8
          Top = 128
          Width = 89
          Height = 28
          Caption = 'Well Bore Outside Diameter'
          WordWrap = True
        end
        object Label34: TLabel
          Left = 8
          Top = 192
          Width = 35
          Height = 14
          Caption = 'Method'
        end
        object adeWellTop: TArgusDataEntry
          Left = 8
          Top = 40
          Width = 89
          Height = 21
          ItemHeight = 14
          TabOrder = 0
          Text = '0'
          Items.Strings = (
            'False'
            'True')
          DataType = dtReal
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object adeWellBottom: TArgusDataEntry
          Left = 8
          Top = 96
          Width = 89
          Height = 21
          ItemHeight = 14
          TabOrder = 1
          Text = '0'
          Items.Strings = (
            'False'
            'True')
          DataType = dtReal
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object adeWellOD: TArgusDataEntry
          Left = 8
          Top = 160
          Width = 89
          Height = 21
          ItemHeight = 14
          TabOrder = 2
          Text = '0'
          Items.Strings = (
            'False'
            'True')
          DataType = dtReal
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object adeWellMethod: TArgusDataEntry
          Left = 8
          Top = 208
          Width = 89
          Height = 21
          ItemHeight = 14
          TabOrder = 3
          Text = '0'
          Items.Strings = (
            'False'
            'True')
          DataType = dtInteger
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object edWellElements: TEdit
          Left = 8
          Top = 256
          Width = 73
          Height = 22
          TabOrder = 4
          Text = '1'
          Visible = False
        end
      end
      object Panel8: TPanel
        Left = 105
        Top = 0
        Width = 493
        Height = 336
        Align = alClient
        TabOrder = 1
        ExplicitWidth = 503
        ExplicitHeight = 354
        object Splitter2: TSplitter
          Left = 1
          Top = 129
          Width = 494
          Height = 3
          Cursor = crVSplit
          Align = alBottom
        end
        object sgWellTime: TStringGrid
          Left = 1
          Top = 132
          Width = 494
          Height = 171
          Align = alBottom
          ColCount = 6
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
          TabOrder = 0
          ColWidths = (
            29
            54
            114
            79
            89
            108)
        end
        object sgWellCompletion: TStringGrid
          Left = 1
          Top = 1
          Width = 494
          Height = 128
          Align = alClient
          ColCount = 4
          FixedCols = 2
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
          TabOrder = 1
          ColWidths = (
            116
            104
            126
            111)
        end
      end
    end
    object tabWellRiser: TTabSheet
      Caption = 'Well-Riser'
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblMaxIterWell: TLabel
        Left = 80
        Top = 16
        Width = 378
        Height = 14
        Caption = 
          'Maximum number of iterations allowed for well-flow rate calculat' +
          'ion (MXITQW)'
        Enabled = False
      end
      object lblTolWell: TLabel
        Left = 80
        Top = 40
        Width = 370
        Height = 14
        Caption = 
          'Tolerance on the change in well-riser pressure (TOLDPW) (F/L^2) ' +
          '(Pa or psi)'
        Enabled = False
      end
      object lblTolFracPresWell: TLabel
        Left = 80
        Top = 64
        Width = 319
        Height = 14
        Caption = 'Tolerance on the fraction change in well-riser pressure (TOLFPW)'
        Enabled = False
      end
      object lblTolFracFlowWell: TLabel
        Left = 80
        Top = 88
        Width = 303
        Height = 14
        Caption = 'Tolerance on the fractional change in well flow rate (TOLFQW)'
        Enabled = False
      end
      object lblDampWell: TLabel
        Left = 80
        Top = 112
        Width = 274
        Height = 14
        Caption = 'Damping factor for well-pressure adjustment (DAMWRC)'
        Enabled = False
      end
      object lblMinStepWell: TLabel
        Left = 80
        Top = 136
        Width = 334
        Height = 14
        Caption = 
          'Minimum value of step length along the well riser (DZMIN) (L) (m' +
          ' or ft)'
        Enabled = False
      end
      object lblFracTolIntWell: TLabel
        Left = 80
        Top = 160
        Width = 440
        Height = 14
        Caption = 
          'Fractional tolerance for the integration of the pressure and tem' +
          'perature equations (EPSWR)'
        Enabled = False
      end
      object lblWellLength: TLabel
        Left = 80
        Top = 184
        Width = 159
        Height = 14
        Caption = 'Well riser pipe length (L) (M or ft)'
        Enabled = False
        Visible = False
      end
      object lblWellRiseID: TLabel
        Left = 80
        Top = 208
        Width = 202
        Height = 14
        Caption = 'Well riser pipe inside diameter (L) (M or ft)'
        Enabled = False
        Visible = False
      end
      object lblWellRough: TLabel
        Left = 80
        Top = 232
        Width = 214
        Height = 14
        Caption = 'Well riser pipe roughness factor (L) (M or ft)'
        Enabled = False
        Visible = False
      end
      object lblWellAngle: TLabel
        Left = 80
        Top = 256
        Width = 206
        Height = 14
        Caption = 'Well Riser pipe angle with vertical direction'
        Enabled = False
        Visible = False
      end
      object lblHeatTransf: TLabel
        Left = 80
        Top = 280
        Width = 175
        Height = 28
        Caption = 'Heat transfer coefficient (E/t-L^2-T) (W/m^2-C or BTU/h-ft^2-F)'
        Enabled = False
        Visible = False
        WordWrap = True
      end
      object lblWellRiseDiff: TLabel
        Left = 368
        Top = 184
        Width = 187
        Height = 28
        Caption = 'Thermal diffusivity of adjacent medium (L^2/t) (m^2/s or ft^2/d)'
        Enabled = False
        Visible = False
        WordWrap = True
      end
      object lblWellRiseCondMedium: TLabel
        Left = 368
        Top = 216
        Width = 188
        Height = 28
        Caption = 
          'Thermal conductivity of adjacent medium (E/L-t-T) (W/m-C or BTU/' +
          'ft-h-F)'
        Enabled = False
        Visible = False
        WordWrap = True
      end
      object lblWellRiseCondPipe: TLabel
        Left = 368
        Top = 248
        Width = 187
        Height = 28
        Caption = 
          'Thermal conductivity of well-riser pipe (E/L-t-T) (W/m-C or BTU/' +
          'ft-h-F)'
        Enabled = False
        Visible = False
        WordWrap = True
      end
      object lblWellBotTemp: TLabel
        Left = 368
        Top = 288
        Width = 153
        Height = 14
        Caption = 'Bottom Temperature (T) (C or F)'
        Enabled = False
        Visible = False
      end
      object lblWellTopTemp: TLabel
        Left = 368
        Top = 312
        Width = 137
        Height = 14
        Caption = 'Top Temperature (T) (C or F)'
        Enabled = False
        Visible = False
      end
      object adeMaxIterWell: TArgusDataEntry
        Left = 8
        Top = 8
        Width = 70
        Height = 22
        Hint = '2.13.7 MXITQW'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        Text = '20'
        DataType = dtInteger
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeTolWell: TArgusDataEntry
        Left = 8
        Top = 32
        Width = 70
        Height = 22
        Hint = '2.13.7 TOLDPW'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
        Text = '0.006'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeTolFracPresWell: TArgusDataEntry
        Left = 8
        Top = 56
        Width = 70
        Height = 22
        Hint = '2.13.7 TOLFPW'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
        Text = '0.001'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeTolFracFlowWell: TArgusDataEntry
        Left = 8
        Top = 80
        Width = 70
        Height = 22
        Hint = '2.13.7 TOLFQW'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        Text = '0.001'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeDampWell: TArgusDataEntry
        Left = 8
        Top = 104
        Width = 70
        Height = 22
        Hint = '2.13.7 DAMWRC'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 4
        Text = '2'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeMinStepWell: TArgusDataEntry
        Left = 8
        Top = 128
        Width = 70
        Height = 22
        Hint = '2.13.7 DZMIN'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 5
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeFracTolIntWell: TArgusDataEntry
        Left = 8
        Top = 152
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 6
        Text = '0.001'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellLength: TArgusDataEntry
        Left = 8
        Top = 176
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        Text = '0'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellRiseID: TArgusDataEntry
        Left = 8
        Top = 200
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        Text = '0'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellRough: TArgusDataEntry
        Left = 8
        Top = 224
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        Text = '0'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellAngle: TArgusDataEntry
        Left = 8
        Top = 248
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        Text = '0'
        Visible = False
        DataType = dtReal
        Max = 90.000000000000000000
        CheckMax = True
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeHeatTransf: TArgusDataEntry
        Left = 8
        Top = 280
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        Text = '0'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellRiseDiff: TArgusDataEntry
        Left = 296
        Top = 184
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        Text = '0'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellRiseCondMedium: TArgusDataEntry
        Left = 296
        Top = 216
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        Text = '0'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellRiseCondPipe: TArgusDataEntry
        Left = 296
        Top = 248
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 14
        Text = '0'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellBotTemp: TArgusDataEntry
        Left = 296
        Top = 280
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
        Text = '20'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeWellTopTemp: TArgusDataEntry
        Left = 296
        Top = 304
        Width = 70
        Height = 22
        Hint = '2.13.7 EPSWR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        Text = '20'
        Visible = False
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
    end
    object tabAqInfl: TTabSheet
      Caption = 'Aquifer Influence'
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblBulkCompOut: TLabel
        Left = 160
        Top = 72
        Width = 345
        Height = 28
        Caption = 
          'Porous-medium bulk vertical compressibility for the outer-aquife' +
          'r region (ABOAR) (F/L^2)^-1 (Pa^-1 or psi^-1)'
        WordWrap = True
      end
      object lblPorOut: TLabel
        Left = 160
        Top = 104
        Width = 276
        Height = 14
        Caption = 'Porosity for the outer-aquifer region (POROAR) (L^3/L^3)'
      end
      object lblVolOut: TLabel
        Left = 160
        Top = 128
        Width = 299
        Height = 14
        Caption = 'Volume of the outer-aquifer region (VOAR) (L^3) (m^3 or ft^3)'
      end
      object lblPermOut: TLabel
        Left = 160
        Top = 152
        Width = 324
        Height = 14
        Caption = 
          'Permeability for the outer-aquifer region (KOAR) (L^2) (m^2 or f' +
          't^2)'
        Enabled = False
      end
      object lblViscOut: TLabel
        Left = 160
        Top = 176
        Width = 370
        Height = 14
        Caption = 
          'Viscosity of the fluid in the outer-aquifer region (VISOAR) (M/L' +
          't) (Pa-s or cP)'
        Enabled = False
      end
      object lblThickOut: TLabel
        Left = 160
        Top = 200
        Width = 301
        Height = 14
        Caption = 'Total thickness of the outer-aquifer region (BOAR) (L) (m or ft)'
        Enabled = False
      end
      object lblRadius: TLabel
        Left = 160
        Top = 224
        Width = 440
        Height = 14
        Caption = 
          'Radius of the equivalent cylinder that contains the inner-aquife' +
          'r region (RIOAR) (L) (m or ft)'
        Enabled = False
      end
      object lblAngInflOut: TLabel
        Left = 160
        Top = 248
        Width = 325
        Height = 14
        Caption = 
          'Angle of influence of the outer aquifer region (ANGOAR) (degrees' +
          ')'
        Enabled = False
      end
      object lblAquiferInflZoneW: TLabel
        Left = 160
        Top = 272
        Width = 208
        Height = 14
        Caption = 'Aquifer influence zone weighting (UVAIFC)'
      end
      object rgAqInflChoice: TRadioGroup
        Left = 8
        Top = 8
        Width = 561
        Height = 57
        Hint = '2.18.3 IAIF'
        Caption = 'Choice of aquifer-influence functions (IAIF)'
        ItemIndex = 0
        Items.Strings = (
          'Pot aquifer for outer-aquifer region'
          
            'Transient-aquifer-influence function with calculation using the ' +
            'Carter-Tracy approximation')
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        OnClick = rgAqInflChoiceClick
      end
      object adeBulkCompOut: TArgusDataEntry
        Left = 8
        Top = 72
        Width = 145
        Height = 22
        Hint = '2.18.4A and 2.18.4B ABOAR'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
        Text = '1e-8'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adePorOut: TArgusDataEntry
        Left = 8
        Top = 96
        Width = 145
        Height = 22
        Hint = '2.18.4A and 2.18.4B POROAR'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
        Text = '0.2'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeVolOut: TArgusDataEntry
        Left = 8
        Top = 120
        Width = 145
        Height = 22
        Hint = '2.18.4A VOAR'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adePermOut: TArgusDataEntry
        Left = 8
        Top = 144
        Width = 145
        Height = 22
        Hint = '2.18.4B KOAR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 4
        Text = '1e-10'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeViscOut: TArgusDataEntry
        Left = 8
        Top = 168
        Width = 145
        Height = 22
        Hint = '2.18.4B VISOAR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 5
        Text = '0.001002'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeThickOut: TArgusDataEntry
        Left = 8
        Top = 192
        Width = 145
        Height = 22
        Hint = '2.18.4B BOAR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 6
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeRadius: TArgusDataEntry
        Left = 8
        Top = 216
        Width = 145
        Height = 22
        Hint = '2.18.4B RIOAR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 7
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeAngInflOut: TArgusDataEntry
        Left = 8
        Top = 240
        Width = 145
        Height = 22
        Hint = '2.18.4B ANGOAR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 8
        Text = '360'
        DataType = dtReal
        Max = 360.000000000000000000
        CheckMax = True
        CheckMin = True
        ChangeDisabledColor = True
      end
      object comboAquiferInflZoneW: TComboBox
        Left = 8
        Top = 264
        Width = 145
        Height = 22
        Hint = '2.18.2 UVAIFC'
        Style = csDropDownList
        ItemHeight = 14
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 9
        OnChange = comboAquiferInflZoneWChange
        Items.Strings = (
          'Default Weighting'
          'User Specified Weighting')
      end
    end
    object tabHeat: TTabSheet
      Caption = 'Heat Conduction B.C.'
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter1: TSplitter
        Left = 0
        Top = 166
        Width = 608
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object pnlInitialHeatCondBoundNodeN: TPanel
        Left = 0
        Top = 169
        Width = 608
        Height = 166
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object sgHeatCondBoundInitialCond: TStringGrid
          Left = 112
          Top = 0
          Width = 496
          Height = 166
          Hint = '2.21.5 ZTHC, TVZHC'
          Align = alClient
          ColCount = 3
          DefaultColWidth = 100
          RowCount = 4
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 0
          OnDrawCell = sgHeatCondBoundInitialCondDrawCell
          OnExit = sgHeatCondBoundInitialCondExit
          OnSelectCell = sgHeatCondBoundInitialCondSelectCell
          OnSetEditText = sgHeatCondBoundInitialCondSetEditText
          ColWidths = (
            60
            170
            185)
          RowHeights = (
            24
            24
            24
            24)
        end
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 112
          Height = 166
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object lblInitialHeatCondBoundNodeN: TLabel
            Left = 16
            Top = 21
            Width = 81
            Height = 84
            Caption = 
              'Number of heat-conduction boundary nodes for initial conditions ' +
              '(2-10) (NZTPHC)'
            WordWrap = True
          end
          object edInitialHeatCondBoundNodeN: TEdit
            Left = 16
            Top = 108
            Width = 81
            Height = 22
            Hint = '2.21.5 NZTPHC'
            ParentShowHint = False
            PopupMenu = PopupMenu1
            ShowHint = True
            TabOrder = 0
            Text = '3'
            OnChange = edInitialHeatCondBoundNodeNChange
            OnExit = edInitialHeatCondBoundNodeNExit
          end
        end
      end
      object pnlHeatCondBoundNodeN: TPanel
        Left = 0
        Top = 0
        Width = 608
        Height = 166
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object sgHeatCondBoundNodeSpacing: TStringGrid
          Left = 112
          Top = 0
          Width = 496
          Height = 166
          Hint = '2.19.1 ZHCBC'
          Align = alClient
          ColCount = 2
          DefaultColWidth = 50
          RowCount = 4
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 0
          OnDrawCell = sgHeatCondBoundNodeSpacingDrawCell
          OnSelectCell = sgHeatCondBoundNodeSpacingSelectCell
          OnSetEditText = sgHeatCondBoundNodeSpacingSetEditText
          ColWidths = (
            50
            369)
          RowHeights = (
            24
            24
            24
            24)
        end
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 112
          Height = 166
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object lblHeatCondBoundNodeN: TLabel
            Left = 16
            Top = 8
            Width = 78
            Height = 70
            Caption = 'Number of heat-conduction boundary nodes (2-10) (NHCN)'
            WordWrap = True
          end
          object edHeatCondBoundNodeN: TEdit
            Left = 16
            Top = 88
            Width = 81
            Height = 22
            Hint = '1.6 NHCH'
            ParentShowHint = False
            PopupMenu = PopupMenu1
            ShowHint = True
            TabOrder = 0
            Text = '3'
            OnChange = edHeatCondBoundNodeNChange
            OnExit = edHeatCondBoundNodeNExit
          end
        end
      end
    end
    object tabInitCond: TTabSheet
      Caption = 'Initial Conditions'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblElevInitPres: TLabel
        Left = 168
        Top = 72
        Width = 294
        Height = 14
        Caption = 
          'Elevation of the initial-condition pressure (ZPINIT) (L) (m or f' +
          't)'
        Enabled = False
      end
      object lblInitPres: TLabel
        Left = 168
        Top = 96
        Width = 373
        Height = 14
        Caption = 
          'Pressure for hydrostatic, initial-condition distribution (PINIT)' +
          ' (F/L^2) (Pa or psi)'
        Enabled = False
      end
      object cbSpecInitPres: TCheckBox
        Left = 16
        Top = 16
        Width = 297
        Height = 17
        Hint = '2.21.1 ICHYDP'
        Caption = 'Specified initial hydrostatic pressure distribution (ICHYDP)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        OnClick = cbSpecInitPresClick
      end
      object cbInitWatTable: TCheckBox
        Left = 16
        Top = 40
        Width = 257
        Height = 17
        Hint = '2.21.2 ICHWT'
        Caption = 'Specified initial water table  (ICHWT)'
        Enabled = False
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
        OnClick = cbInitWatTableClick
      end
      object adeElevInitPres: TArgusDataEntry
        Left = 16
        Top = 64
        Width = 145
        Height = 22
        Hint = '2.21.3A ZPINIT'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeInitPres: TArgusDataEntry
        Left = 16
        Top = 88
        Width = 145
        Height = 22
        Hint = '2.21.3A PINIT'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object cbWatTableInitialInterp: TCheckBox
        Left = 16
        Top = 136
        Width = 313
        Height = 17
        Caption = 'Allow interpolation along open contours for initial water table'
        Enabled = False
        PopupMenu = PopupMenu1
        TabOrder = 4
        OnClick = cbWatTableInitialInterpClick
      end
      object cbInitPresInterp: TCheckBox
        Left = 16
        Top = 120
        Width = 313
        Height = 17
        Caption = 'Allow interpolation along open contours for initial pressure'
        PopupMenu = PopupMenu1
        TabOrder = 5
        OnClick = cbInitPresInterpClick
      end
    end
    object tabSolver: TTabSheet
      Caption = 'Calculation'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label16: TLabel
        Left = 96
        Top = 4
        Width = 153
        Height = 28
        Caption = 'Factor for spatial-discretization (FDSMTH)'
        WordWrap = True
      end
      object Label17: TLabel
        Left = 368
        Top = 12
        Width = 211
        Height = 14
        Hint = '2.22.1 FDTMTH'
        Caption = 'Factor for temporal-discretization (FDTMTH)'
        WordWrap = True
      end
      object Label18: TLabel
        Left = 96
        Top = 32
        Width = 170
        Height = 28
        Hint = '2.22.2 TOLDEN'
        Caption = 
          'Tolerance in fractional change in density for convergence (TOLDE' +
          'N)'
        WordWrap = True
      end
      object Label19: TLabel
        Left = 368
        Top = 32
        Width = 194
        Height = 28
        Caption = 'Maximum number of iterations per cycle (MAXITN)'
        WordWrap = True
      end
      object lblNumTime: TLabel
        Left = 96
        Top = 168
        Width = 366
        Height = 28
        Caption = 
          'Number ot time steps between recalculations of the optimum-overr' +
          'elaxation parameter (NTSOPT)'
        Enabled = False
        WordWrap = True
      end
      object lblTolerance: TLabel
        Left = 96
        Top = 184
        Width = 47
        Height = 14
        Caption = 'Tolerance'
        Enabled = False
        WordWrap = True
      end
      object lblTolerance2: TLabel
        Left = 96
        Top = 216
        Width = 170
        Height = 42
        Caption = 
          'Tolerance on the fractional change in the overrelaxation paramet' +
          'er (EPSOMG)'
        Enabled = False
        WordWrap = True
      end
      object lblMaxIt1: TLabel
        Left = 368
        Top = 216
        Width = 217
        Height = 42
        Caption = 
          'Maximum number of iterations allowed for the calculation of the ' +
          'optimum overrelaxation parameter (MAXIT1)'
        Enabled = False
        WordWrap = True
      end
      object lblMaxIt2: TLabel
        Left = 96
        Top = 256
        Width = 176
        Height = 42
        Caption = 
          'Maximum number of iterations allowed for the solution of the mat' +
          'rix equations (MAXIT2)'
        Enabled = False
        WordWrap = True
      end
      object lblRenumDir: TLabel
        Left = 368
        Top = 264
        Width = 121
        Height = 14
        Caption = 'Renumbering order (IDIR)'
        Enabled = False
      end
      object lblIORDER: TLabel
        Left = 240
        Top = 312
        Width = 159
        Height = 14
        Caption = 'Preconditioning method (IORDER)'
        Enabled = False
      end
      object lblNumSteps: TLabel
        Left = 368
        Top = 280
        Width = 216
        Height = 28
        Caption = 'Number of steps between restarts of solver (NSDR)'
        Enabled = False
        WordWrap = True
      end
      object adeSpatDiscFac: TArgusDataEntry
        Left = 8
        Top = 8
        Width = 81
        Height = 22
        Hint = '2.22.1 FDSMTH'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        Text = '0'
        DataType = dtReal
        Max = 0.500000000000000000
        CheckMax = True
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeTempDiscFact: TArgusDataEntry
        Left = 280
        Top = 8
        Width = 81
        Height = 22
        Hint = '2.22.1 FDTMTH'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
        Text = '1'
        DataType = dtReal
        Max = 1.000000000000000000
        Min = 0.500000000000000000
        CheckMax = True
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeTolFracDens: TArgusDataEntry
        Left = 8
        Top = 32
        Width = 81
        Height = 22
        Hint = '2.22.2 TOLDEN'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
        Text = '0.001'
        DataType = dtReal
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeMaxIter: TArgusDataEntry
        Left = 280
        Top = 32
        Width = 81
        Height = 22
        Hint = '2.22.2 MAXITN'
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        Text = '5'
        DataType = dtInteger
        Max = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeNumTime: TArgusDataEntry
        Left = 8
        Top = 160
        Width = 81
        Height = 22
        Hint = '2.22.3 NTSOPT'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 5
        Text = '5'
        DataType = dtInteger
        Max = 1.000000000000000000
        Min = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object adeTolerance: TArgusDataEntry
        Left = 8
        Top = 184
        Width = 81
        Height = 22
        Hint = '2.22.3 and 2.22.4 EPSSLV'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 6
        Text = '1e-7'
        DataType = dtReal
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeTolerance2: TArgusDataEntry
        Left = 8
        Top = 216
        Width = 81
        Height = 22
        Hint = '2.22.3 EPSOMG'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 7
        Text = '0.2'
        DataType = dtReal
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeMaxIt1: TArgusDataEntry
        Left = 280
        Top = 216
        Width = 81
        Height = 22
        Hint = '2.22.3 MAXIT1'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 8
        Text = '50'
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeMaxIt2: TArgusDataEntry
        Left = 8
        Top = 256
        Width = 81
        Height = 22
        Hint = '2.22.3 and 2.22.4 MAXIT2'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 9
        Text = '100'
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeNumSteps: TArgusDataEntry
        Left = 280
        Top = 280
        Width = 81
        Height = 22
        Hint = '2.22.4 NSDR'
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 11
        Text = '5'
        DataType = dtInteger
        Max = 5.000000000000000000
        Min = 1.000000000000000000
        CheckMin = True
        ChangeDisabledColor = True
      end
      object comboRenumDir: TComboBox
        Left = 280
        Top = 256
        Width = 81
        Height = 22
        Hint = '2.22.4 IDIR'
        Style = csDropDownList
        Enabled = False
        ItemHeight = 14
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 10
        Items.Strings = (
          'xyz'
          'xzy'
          'yxz'
          'yzx'
          'zxy'
          'zyx')
      end
      object comboIORDER: TComboBox
        Left = 8
        Top = 304
        Width = 225
        Height = 22
        Hint = '2.22.4 IORDER'
        Style = csDropDownList
        Enabled = False
        ItemHeight = 14
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 12
        Items.Strings = (
          'standard incomplete LU factorization'
          'modified incomplete LU factorization')
      end
      object rgSolutionMethod: TRadioGroup
        Left = 8
        Top = 60
        Width = 553
        Height = 97
        Hint = '1.8 SLMETH'
        Caption = 'Solution Method (SLMETH)'
        Ctl3D = True
        ItemIndex = 0
        Items.Strings = (
          'triangular-factorization direct solver'
          'two-line, successive overrelaxation solver (obscelescent)'
          
            'generalized conjugate gradient iterative solver with red-black r' +
            'enumbering'
          
            'generalized conjugate gradient iterative solver with alternating' +
            '-diagonal zig-zag renumbering')
        ParentCtl3D = False
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 4
        OnClick = rgSolutionMethodClick
      end
    end
    object tabOutput: TTabSheet
      Caption = 'Output'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblPrPres: TLabel
        Left = 352
        Top = 48
        Width = 113
        Height = 14
        Caption = 'Print pressure (IPRPTC)'
        Enabled = False
      end
      object lblPrTemp: TLabel
        Left = 352
        Top = 96
        Width = 127
        Height = 14
        Caption = 'Print temperature (IPRPTC)'
        Enabled = False
      end
      object lblPrMassFr: TLabel
        Left = 352
        Top = 144
        Width = 135
        Height = 14
        Caption = 'Print mass fraction (IPRPTC)'
        Enabled = False
      end
      object lblPrOrientation: TLabel
        Left = 8
        Top = 144
        Width = 190
        Height = 14
        Caption = 'Orientation of array printouts (OPENPR)'
      end
      object Label14: TLabel
        Left = 136
        Top = 264
        Width = 225
        Height = 14
        Caption = 'Extension for Output (14 characters maximum)'
      end
      object Label15: TLabel
        Left = 136
        Top = 240
        Width = 94
        Height = 14
        Caption = 'Data input file name'
      end
      object Label20: TLabel
        Left = 8
        Top = 192
        Width = 57
        Height = 14
        Caption = 'HST3D Path'
      end
      object Label7: TLabel
        Left = 372
        Top = 24
        Width = 134
        Height = 14
        Caption = 'of Initial Conditions (PRTDV)'
      end
      object cbPriPorous: TCheckBox
        Left = 8
        Top = 8
        Width = 233
        Height = 17
        Hint = '2.23.1 PRTPMP'
        Caption = 'Print porous-media properties (PRTPMP)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
      end
      object cbPrFluidProp: TCheckBox
        Left = 8
        Top = 24
        Width = 161
        Height = 17
        Hint = '2.23.1 PRTFP'
        Caption = 'Print fluid properties (PRTFP)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
      end
      object cbPrStat: TCheckBox
        Left = 8
        Top = 56
        Width = 257
        Height = 17
        Hint = '2.23.1 PRTBC'
        Caption = 'Print static boundary condition data (PRTBC)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 4
      end
      object cbPrSolMeth: TCheckBox
        Left = 8
        Top = 72
        Width = 233
        Height = 17
        Hint = '2.23.1 PRTSLM'
        Caption = 'Print solution-method information (PRTSLM)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 6
      end
      object cbPrStatWell: TCheckBox
        Left = 8
        Top = 88
        Width = 225
        Height = 17
        Hint = '2.23.1 PRTWEL'
        Caption = 'Print static well-bore information (PRTWEL)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 7
      end
      object cbPrDensVisc: TCheckBox
        Left = 352
        Top = 8
        Width = 225
        Height = 17
        Hint = '2.23.2 PRTDV'
        Caption = 'Print density and viscosity arrays'
        Enabled = False
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
      end
      object comboPrPres: TComboBox
        Left = 352
        Top = 64
        Width = 169
        Height = 22
        Hint = '2.23.2 IPRPTC, first digit'
        Style = csDropDownList
        Enabled = False
        ItemHeight = 14
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 5
        Items.Strings = (
          'don'#39't print'
          'pressure'
          'pressure and head')
      end
      object comboPrTemp: TComboBox
        Left = 352
        Top = 112
        Width = 169
        Height = 22
        Hint = '2.23.2 IPRPTC, second digit'
        Style = csDropDownList
        Enabled = False
        ItemHeight = 14
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 9
        Items.Strings = (
          'don'#39't print'
          'temperature'
          'temperature and fluid enthalpy')
      end
      object comboPrMassFr: TComboBox
        Left = 352
        Top = 160
        Width = 169
        Height = 22
        Hint = '2.23.2 IPRPTC, third digit'
        Style = csDropDownList
        Enabled = False
        ItemHeight = 14
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 12
        Items.Strings = (
          'don'#39't print'
          'mass fraction')
      end
      object comboPrOrientation: TComboBox
        Left = 8
        Top = 160
        Width = 321
        Height = 22
        Hint = '2.23.3 OPENPR'
        Style = csDropDownList
        ItemHeight = 14
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 11
        Items.Strings = (
          'Planes perpendicular to z axis, horizontal slices'
          'Planes perpendicular to y axis, vertical slices')
      end
      object cbPrInit: TCheckBox
        Left = 8
        Top = 40
        Width = 177
        Height = 17
        Hint = '2.23.1 PRTIC'
        Caption = 'Print initial conditions (PRTIC)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        OnClick = cbPrInitClick
      end
      object cbPrPorZone: TCheckBox
        Left = 8
        Top = 104
        Width = 337
        Height = 17
        Hint = '2.23.4 PLTZON'
        Caption = 
          'Print data for a plot of the porous-media property zones (PLTZON' +
          ')'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 8
      end
      object cbPrPostProc: TCheckBox
        Left = 8
        Top = 120
        Width = 313
        Height = 17
        Hint = '2.23.5 PLTTEM'
        Caption = 'Print temporal well data for post-processing plots (PLTTEM)'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 10
      end
      object edExtension: TEdit
        Left = 8
        Top = 256
        Width = 121
        Height = 22
        PopupMenu = PopupMenu1
        TabOrder = 18
        Text = 'Out'
        OnChange = edExtensionChange
        OnExit = edExtensionExit
      end
      object edInput: TEdit
        Left = 8
        Top = 232
        Width = 121
        Height = 22
        PopupMenu = PopupMenu1
        TabOrder = 16
        Text = 'Userspec'
        OnExit = edInputExit
      end
      object edPath: TEdit
        Left = 8
        Top = 208
        Width = 353
        Height = 22
        PopupMenu = PopupMenu1
        TabOrder = 13
        Text = 'C:\Program Files\Argus Interware\ARGUSPIE\HST3D_GUI\hst3d.exe'
        OnChange = edPathChange
      end
      object btnBrowseHST3D: TButton
        Left = 384
        Top = 208
        Width = 75
        Height = 21
        Caption = 'Browse'
        PopupMenu = PopupMenu1
        TabOrder = 14
        OnClick = btnBrowseHST3DClick
      end
      object rgExportDecision: TRadioGroup
        Left = 384
        Top = 232
        Width = 193
        Height = 81
        Caption = 'rgExportDecision'
        Items.Strings = (
          'Create HST3D input files'
          'Create HST3D input files and run HST3D'
          'Create BCFLOW input files'
          'Create BCFLOW input files and run BCFLOW')
        TabOrder = 17
        Visible = False
      end
      object cbPauseDos: TCheckBox
        Left = 464
        Top = 216
        Width = 113
        Height = 17
        Caption = 'Pause when done'
        Checked = True
        State = cbChecked
        TabOrder = 15
        Visible = False
        OnClick = cbPauseDosClick
      end
    end
    object tabTime: TTabSheet
      Caption = 'Time'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sgSolver: TStringGrid
        Left = 0
        Top = 0
        Width = 608
        Height = 299
        Hint = '3.8.2 to 3.10.1'
        Align = alClient
        DefaultColWidth = 90
        RowCount = 27
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = False
        TabOrder = 0
        OnDrawCell = sgSolverDrawCell
        OnExit = sgSolverExit
        OnMouseMove = sgSolverMouseMove
        OnSelectCell = sgSolverSelectCell
        OnSetEditText = sgSolverSetEditText
        ColWidths = (
          298
          90
          90
          90
          90)
        RowHeights = (
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24)
      end
      object Panel3: TPanel
        Left = 0
        Top = 299
        Width = 608
        Height = 52
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object lblMaxTimes: TLabel
          Left = 88
          Top = 13
          Width = 227
          Height = 14
          Caption = 'Maximum number of time periods for any object'
        end
        object edMaxTimes: TEdit
          Left = 8
          Top = 8
          Width = 73
          Height = 22
          Hint = 'Changes to take place only after you click outside the edit box.'
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 0
          Text = '1'
          OnEnter = edMaxTimesEnter
          OnExit = edMaxTimesExit
        end
        object btnAddTime: TButton
          Left = 336
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Add Time'
          PopupMenu = PopupMenu1
          TabOrder = 1
          OnClick = btnAddTimeClick
        end
        object btnDelTime: TButton
          Left = 416
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Delete Time'
          Enabled = False
          PopupMenu = PopupMenu1
          TabOrder = 2
          OnClick = btnDelTimeClick
        end
        object btnInsertTime: TButton
          Left = 496
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Insert Time'
          PopupMenu = PopupMenu1
          TabOrder = 3
          OnClick = btnInsertTimeClick
        end
        object StatusBar1: TStatusBar
          Left = 0
          Top = 33
          Width = 608
          Height = 19
          Panels = <>
          SimplePanel = True
          SizeGrip = False
        end
      end
    end
    object tabBCFLOW: TTabSheet
      Caption = 'BCFLOW'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label12: TLabel
        Left = 8
        Top = 32
        Width = 186
        Height = 14
        Caption = 'Boundary Condition types to be totaled'
      end
      object Label13: TLabel
        Left = 8
        Top = 192
        Width = 68
        Height = 14
        Caption = 'BCFLOW Path'
      end
      object lblBCFLOWTitle1: TLabel
        Left = 8
        Top = 240
        Width = 98
        Height = 14
        Caption = 'BCFLOW Title Line 1'
        Enabled = False
      end
      object lblBCFLOWTitle2: TLabel
        Left = 8
        Top = 288
        Width = 98
        Height = 14
        Caption = 'BCFLOW Title Line 2'
        Enabled = False
      end
      object cbUseBCFLOW: TCheckBox
        Left = 8
        Top = 8
        Width = 97
        Height = 17
        Caption = 'Use BCFLOW'
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnClick = cbUseBCFLOWClick
      end
      object cbBCFLOWUseSpecState: TCheckBox
        Left = 8
        Top = 48
        Width = 489
        Height = 17
        Caption = 
          'Specified Value (specified pressure, specified temperature, or s' +
          'pecified mass fraction)'
        Enabled = False
        PopupMenu = PopupMenu1
        TabOrder = 1
        OnClick = cbBCFLOWParameterClick
      end
      object cbBCFLOWUseSpecFlux: TCheckBox
        Left = 8
        Top = 72
        Width = 417
        Height = 17
        Caption = 
          'Specified Flux (specified fluid flux, specified heat flux, speci' +
          'fied solute flux)'
        Enabled = False
        PopupMenu = PopupMenu1
        TabOrder = 2
        OnClick = cbBCFLOWParameterClick
      end
      object cbBCFLOWUseLeakage: TCheckBox
        Left = 8
        Top = 96
        Width = 249
        Height = 17
        Caption = 'Leakage (aquifer leakage, river leakage)'
        Enabled = False
        PopupMenu = PopupMenu1
        TabOrder = 3
        OnClick = cbBCFLOWParameterClick
      end
      object cbBCFLOWUseAqInfl: TCheckBox
        Left = 8
        Top = 120
        Width = 113
        Height = 17
        Caption = 'Aquifer Influence'
        Enabled = False
        PopupMenu = PopupMenu1
        TabOrder = 4
        OnClick = cbBCFLOWParameterClick
      end
      object cbBCFLOWUseHeatCond: TCheckBox
        Left = 8
        Top = 144
        Width = 177
        Height = 17
        Caption = 'Heat Conduction'
        Enabled = False
        PopupMenu = PopupMenu1
        TabOrder = 5
        OnClick = cbBCFLOWParameterClick
      end
      object cbBCFLOWUseET: TCheckBox
        Left = 8
        Top = 168
        Width = 137
        Height = 17
        Caption = 'Evapotranspiration'
        Enabled = False
        PopupMenu = PopupMenu1
        TabOrder = 6
        OnClick = cbBCFLOWParameterClick
      end
      object edBCFLOWPath: TEdit
        Left = 8
        Top = 208
        Width = 401
        Height = 22
        PopupMenu = PopupMenu1
        TabOrder = 7
        Text = 'C:\Program Files\Argus Interware\ARGUSPIE\HST3D_GUI\bcflow.exe'
        OnChange = edBCFLOWPathChange
      end
      object btnBrowseBCFLOW: TButton
        Left = 416
        Top = 208
        Width = 75
        Height = 25
        Caption = 'Browse'
        TabOrder = 8
        OnClick = btnBrowseBCFLOWClick
      end
      object adeBCFLOWTitle1: TArgusDataEntry
        Left = 8
        Top = 256
        Width = 401
        Height = 22
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        MaxLength = 79
        PopupMenu = PopupMenu1
        TabOrder = 9
        Text = 'BCFLOW Title Line 1'
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeBCFLOWTitle2: TArgusDataEntry
        Left = 8
        Top = 304
        Width = 401
        Height = 22
        Color = clBtnFace
        Enabled = False
        ItemHeight = 0
        MaxLength = 79
        PopupMenu = PopupMenu1
        TabOrder = 10
        Text = 'BCFLOW Title Line 2'
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 384
    Width = 606
    Height = 42
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 402
    ExplicitWidth = 616
    object Panel6: TPanel
      Left = 149
      Top = 1
      Width = 466
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnLoad: TButton
        Left = 16
        Top = 8
        Width = 107
        Height = 25
        Caption = 'Load From "Val" File'
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnClick = btnLoadClick
      end
      object btnSaveDefault: TButton
        Left = 128
        Top = 8
        Width = 91
        Height = 25
        Hint = 
          'Use the default name and directory to create a file of default v' +
          'alues that will be read each time you start a new HST3D model.'
        Caption = 'Save to "Val" file'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 1
        OnClick = btnSaveDefaultClick
      end
      object BitBtnCancel: TBitBtn
        Left = 304
        Top = 8
        Width = 75
        Height = 25
        Hint = 'Reject all changes'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 2
        Kind = bkCancel
      end
      object BitBtnOK: TBitBtn
        Left = 382
        Top = 8
        Width = 75
        Height = 25
        Hint = 'Accept all changes'
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 3
        OnClick = BitBtnOKClick
        Kind = bkOK
      end
      object bitbtnHelp: TBitBtn
        Left = 224
        Top = 8
        Width = 75
        Height = 25
        Caption = '&Help'
        PopupMenu = PopupMenu1
        TabOrder = 4
        OnClick = bitbtnHelpClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
          3333333333333FF3333333330000333333364463333333333333388F33333333
          00003333333E66433333333333338F38F3333333000033333333E66333333333
          33338FF8F3333333000033333333333333333333333338833333333300003333
          3333446333333333333333FF3333333300003333333666433333333333333888
          F333333300003333333E66433333333333338F38F333333300003333333E6664
          3333333333338F38F3333333000033333333E6664333333333338F338F333333
          0000333333333E6664333333333338F338F3333300003333344333E666433333
          333F338F338F3333000033336664333E664333333388F338F338F33300003333
          E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
          3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
          E333333333388FFFFF8333330000333333333333333333333333388888333333
          0000}
        NumGlyphs = 2
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'val'
    Filter = 'Val Files|*.val|All Files|*.*'
    Left = 37
    Top = 384
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'val'
    Filter = 'Val Files|*.val|All Files|*.*'
    Left = 8
    Top = 384
  end
  object PopupMenu1: TPopupMenu
    Left = 66
    Top = 384
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
  end
  object StrSet1: TStrSet
    Strings.Strings = (
      '# '
      '# You can use this template to export a series of points at'
      '# each of the node locations.'
      '# '
      'Define Variable: RowIndex [Real]'
      'Define Variable: ColumnIndex [Real]'
      'Define Variable: NodeX [Real]'
      'Define Variable: NodeY [Real]'
      'Define Variable: Distance [Real]'
      'Define Variable: Angle [Real]'
      'Redirect output to: $BaseName$'
      #9'Loop for: Variable RowIndex from: 0 to: NumRows() step: 1'
      
        #9#9'Loop for: Variable ColumnIndex from: 0 to: NumColumns() step: ' +
        '1'
      #9#9#9'Start a new line'
      #9#9#9#9'Export expression: 1 [G0]'
      #9#9#9'End line'
      #9#9#9'Start a new line'
      #9#9#9#9'If: (GridAngle()=0)'
      #9#9#9#9#9'Export expression: NthColumnPos(ColumnIndex); [G0]'
      #9#9#9#9#9'Export expression: NthRowPos(RowIndex) [G0]'
      #9#9#9#9'Else'
      
        #9#9#9#9#9'Set Variable: Distance:= Sqrt(NthColumnPos(ColumnIndex)*Nth' +
        'ColumnPos(ColumnIndex)+NthRowPos(RowIndex)*NthRowPos(RowIndex))'
      
        #9#9#9#9#9'Set Variable: Angle:= ATan2(NthColumnPos(ColumnIndex), NthR' +
        'owPos(RowIndex))'
      #9#9#9#9#9'Set Variable: Angle:= Angle - GridAngle()'
      #9#9#9#9#9'Set Variable: NodeY:= Cos(Angle) * Distance'
      #9#9#9#9#9'Set Variable: NodeX:= Sin(Angle) * Distance'
      #9#9#9#9#9'Export expression: NodeX; [G0]'
      #9#9#9#9#9'Export expression: NodeY; [G0]'
      #9#9#9#9'End if'
      #9#9#9'End line'
      #9#9'End loop'
      #9'End loop'
      'End file'
      '')
    Left = 124
    Top = 384
  end
end
