inherited frmParameterValues: TfrmParameterValues
  Width = 589
  Height = 521
  Caption = 'Parameter Values - Quick Set'
  Font.Height = -13
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox5: TGroupBox
    Left = 0
    Top = 0
    Width = 581
    Height = 453
    Align = alClient
    Caption = 'Quickly set values of Argus ONE Parameters in all Units at once'
    TabOrder = 0
    inline FramDMaxHydCond: TFrmDefaultValue
      Left = 2
      Top = 18
      Width = 577
      Height = 24
      Align = alTop
      inherited lblParameterName: TLabel
        Width = 185
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Maximum hydraulic conductivity'
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        Text = '1.0E-3'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Permeability'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'maximum'
      end
    end
    inline FramDMinHydCond: TFrmDefaultValue
      Left = 2
      Top = 66
      Width = 577
      Height = 32
      Align = alTop
      TabOrder = 1
      inherited lblParameterName: TLabel
        Width = 181
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Minimum hydraulic conductivity'
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        Text = '1.0E-3'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Permeability'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'minimum'
      end
    end
    inline FramLongDispMax: TFrmDefaultValue
      Left = 2
      Top = 282
      Width = 577
      Height = 24
      Align = alTop
      TabOrder = 2
      inherited lblParameterName: TLabel
        Width = 336
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Longitudinal dispersivity in maximum permeabilty direction'
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        Text = '0.5'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Dispersivity'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'longdisp_in_max_permdir'
      end
    end
    inline FramLongDispMin: TFrmDefaultValue
      Left = 2
      Top = 330
      Width = 577
      Height = 32
      Align = alTop
      TabOrder = 3
      inherited lblParameterName: TLabel
        Width = 339
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Longitudinal dispersivity in minimum permeability direction '
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        Text = '0.5'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Dispersivity'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'longdisp_in_min_permdir'
      end
    end
    inline FramTransvDispMax: TFrmDefaultValue
      Left = 2
      Top = 362
      Width = 577
      Height = 24
      Align = alTop
      TabOrder = 4
      inherited lblParameterName: TLabel
        Width = 336
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Transverse dispersivity in maximum permeability direction '
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        Text = '0.5'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Dispersivity'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'trandisp_in_max_permdir'
      end
    end
    inline FramTransvDispMin: TFrmDefaultValue
      Left = 2
      Top = 410
      Width = 577
      Height = 24
      Align = alTop
      TabOrder = 5
      inherited lblParameterName: TLabel
        Width = 332
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Transverse dispersivity in minimum permeability direction '
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        Text = '0.5'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Dispersivity'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'trandisp_in_min_permdir'
      end
    end
    inline FramPor: TFrmDefaultValue
      Left = 2
      Top = 178
      Width = 577
      Height = 24
      Align = alTop
      TabOrder = 6
      inherited lblParameterName: TLabel
        Width = 48
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Porosity'
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        Text = '0.1'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Porosity'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'porosity'
      end
    end
    inline FramInitTempConc: TFrmDefaultValue
      Left = 2
      Top = 250
      Width = 577
      Height = 32
      Align = alTop
      TabOrder = 7
      inherited lblParameterName: TLabel
        Width = 200
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Initial concentration or temperature'
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Initial Conc or Temp'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'initial_conc_or_temp'
      end
    end
    inline FramPermAngleXY: TFrmDefaultValue
      Left = 2
      Top = 98
      Width = 577
      Height = 24
      Align = alTop
      TabOrder = 8
      inherited lblParameterName: TLabel
        Width = 161
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Hydraulic conductivity angle'
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Permeability'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'horizontal angle'
      end
    end
    inline FramInitPres: TFrmDefaultValue
      Left = 2
      Top = 226
      Width = 577
      Height = 24
      Align = alTop
      TabOrder = 9
      inherited lblParameterName: TLabel
        Width = 62
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Initial head'
      end
      inherited adeProperty: TArgusDataEntry
        ItemHeight = 16
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Initial Pressure'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'initial_pressure'
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 202
      Width = 577
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 10
      object Label123: TLabel
        Left = 168
        Top = 5
        Width = 59
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Thickness'
      end
      object adeThickness: TArgusDataEntry
        Left = 88
        Top = 3
        Width = 73
        Height = 22
        ItemHeight = 16
        TabOrder = 0
        Text = '1'
        OnChange = adeThicknessChange
        Max = 1
        ChangeDisabledColor = True
      end
      object btnSetThicknessValue: TButton
        Left = 8
        Top = 3
        Width = 73
        Height = 22
        Caption = 'Set Now'
        Enabled = False
        TabOrder = 1
        OnClick = btnSetThicknessValueClick
      end
    end
    inline FramDMidHydCond: TFrmDefaultValue
      Left = 2
      Top = 42
      Width = 577
      Height = 24
      Align = alTop
      Enabled = False
      TabOrder = 11
      inherited lblParameterName: TLabel
        Width = 170
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Middle hydraulic conductivity '
      end
      inherited adeProperty: TArgusDataEntry
        Color = clBtnFace
        Enabled = False
        ItemHeight = 16
        Text = '1.0E-3'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Permeability'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'middle'
      end
    end
    inline FramPermAngleRotational: TFrmDefaultValue
      Left = 2
      Top = 146
      Width = 577
      Height = 32
      Align = alTop
      Enabled = False
      TabOrder = 12
      inherited lblParameterName: TLabel
        Width = 225
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Rotational hydraulic conductivity angle '
      end
      inherited adeProperty: TArgusDataEntry
        Color = clBtnFace
        Enabled = False
        ItemHeight = 16
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Permeability'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'rotational angle'
      end
    end
    inline FramPermAngleVertical: TFrmDefaultValue
      Left = 2
      Top = 122
      Width = 577
      Height = 24
      Align = alTop
      Enabled = False
      TabOrder = 13
      inherited lblParameterName: TLabel
        Width = 211
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Vertical hydraulic conductivity angle '
      end
      inherited adeProperty: TArgusDataEntry
        Color = clBtnFace
        Enabled = False
        ItemHeight = 16
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Permeability'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'vertical angle'
      end
    end
    inline FramLongDispMid: TFrmDefaultValue
      Left = 2
      Top = 306
      Width = 577
      Height = 24
      Align = alTop
      Enabled = False
      TabOrder = 14
      inherited lblParameterName: TLabel
        Width = 324
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Longitudinal dispersivity in middle permeability direction '
      end
      inherited adeProperty: TArgusDataEntry
        Color = clBtnFace
        Enabled = False
        ItemHeight = 16
        Text = '0.5'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Dispersivity'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'longdisp_in_mid_permdir'
      end
    end
    inline FramTransvDisp1Mid: TFrmDefaultValue
      Left = 2
      Top = 386
      Width = 577
      Height = 24
      Align = alTop
      Enabled = False
      TabOrder = 15
      inherited lblParameterName: TLabel
        Width = 317
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Transverse dispersivity in middle permeability direction '
      end
      inherited adeProperty: TArgusDataEntry
        Color = clBtnFace
        Enabled = False
        ItemHeight = 16
        Text = '0.5'
        OnChange = FramDMaxHydCondadePropertyChange
      end
      inherited LayerClassName: TStringStorage
        StringVariable = 'Dispersivity'
      end
      inherited ParameterClassName: TStringStorage
        StringVariable = 'trandisp_in_mid_permdir'
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 453
    Width = 581
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnDone: TBitBtn
      Left = 496
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Done'
      TabOrder = 0
      OnClick = btnDoneClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
        F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
        000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
        338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
        45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
        3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
        F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
        000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
        338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
        4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
        8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
        0000}
      NumGlyphs = 2
    end
    object btnSetAll: TButton
      Left = 416
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Set All'
      TabOrder = 1
      OnClick = btnSetAllClick
    end
  end
end
