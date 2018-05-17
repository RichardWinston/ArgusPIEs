object frameRegionParams: TframeRegionParams
  Left = 0
  Top = 0
  Width = 607
  Height = 334
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  inline frameRelativePermeability: TframePerm
    Left = 0
    Top = 147
    Width = 607
    Height = 90
    Align = alClient
    TabOrder = 0
    inherited GroupBox1: TGroupBox
      Width = 607
      inherited JvPageListMain: TJvPageList
        Width = 603
        inherited jvsp0None: TJvStandardPage
          Width = 603
        end
        inherited jvsp1VGEN: TJvStandardPage
          Width = 603
        end
        inherited jvsp2BCOR: TJvStandardPage
          Width = 603
        end
        inherited jvsp3PLIN: TJvStandardPage
          Width = 603
        end
        inherited jvsp4IMPE: TJvStandardPage
          Width = 603
        end
        inherited jvsp5UDEF: TJvStandardPage
          Width = 603
          DesignSize = (
            603
            73)
          inherited rdg5RKPAR: TRbwDataGrid4
            Width = 377
          end
        end
      end
    end
  end
  inline frameUnsat: TframeUnsat
    Left = 0
    Top = 33
    Width = 607
    Height = 114
    Align = alTop
    TabOrder = 1
    inherited GroupBox1: TGroupBox
      Width = 607
      Height = 114
      inherited JvPageListMain: TJvPageList
        Width = 603
        Height = 97
        inherited jvsp0None: TJvStandardPage
          Width = 603
          Height = 97
        end
        inherited jvsp1VGEN: TJvStandardPage
          Width = 603
          Height = 97
        end
        inherited jvsp2BCOR: TJvStandardPage
          Width = 603
          Height = 97
        end
        inherited jvsp3PLIN: TJvStandardPage
          Width = 603
          Height = 97
        end
        inherited jvsp4UDEF: TJvStandardPage
          Width = 603
          Height = 97
          DesignSize = (
            603
            97)
          inherited rdg4SWPAR: TRbwDataGrid4
            Width = 377
          end
        end
      end
    end
  end
  inline frameIceSat: TframeIceSat
    Left = 0
    Top = 237
    Width = 607
    Height = 97
    Align = alBottom
    TabOrder = 2
    inherited GroupBox1: TGroupBox
      Width = 607
      Height = 97
      inherited JvPageListMain: TJvPageList
        Width = 603
        Height = 80
        inherited jvsp0None: TJvStandardPage
          Width = 603
          Height = 80
        end
        inherited jvsp1EXPO: TJvStandardPage
          Width = 603
          Height = 80
        end
        inherited jvsp2PLIN: TJvStandardPage
          Width = 603
          Height = 80
        end
        inherited jvsp3UDEF: TJvStandardPage
          Width = 603
          Height = 80
          DesignSize = (
            603
            80)
          inherited rdg3SIPAR: TRbwDataGrid4
            Width = 377
          end
        end
      end
    end
  end
  object pnlCaption: TPanel
    Left = 0
    Top = 0
    Width = 607
    Height = 33
    Align = alTop
    Caption = 'pnlCaption'
    TabOrder = 3
  end
end
