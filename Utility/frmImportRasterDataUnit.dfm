inherited frmImportRasterData: TfrmImportRasterData
  Left = 376
  Top = 294
  HelpContext = 233
  Caption = 'Import ASCII Raster Data'
  ClientHeight = 325
  ClientWidth = 500
  Font.Height = -16
  ExplicitWidth = 518
  ExplicitHeight = 370
  PixelsPerInch = 120
  TextHeight = 19
  object pcFilter: TPageControl [0]
    Left = 250
    Top = 0
    Width = 250
    Height = 218
    ActivePage = tabMesh
    Align = alClient
    TabOrder = 1
    object tabGrid: TTabSheet
      Caption = 'tabGrid'
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object rgGrid: TRadioGroup
        Left = 0
        Top = 0
        Width = 242
        Height = 129
        Align = alClient
        Caption = 'Data to import'
        ItemIndex = 1
        Items.Strings = (
          'Closest value to block nodal point'
          'Mean value in block'
          'Highest value in block'
          'Lowest value in block'
          'All (can take a long time)')
        TabOrder = 0
      end
      object rgGridType: TRadioGroup
        Left = 0
        Top = 129
        Width = 242
        Height = 79
        Align = alBottom
        Caption = 'Grid Type'
        Color = clRed
        Items.Strings = (
          'Block Centered (MODFLOW)'
          'Node Centered')
        ParentColor = False
        TabOrder = 1
        OnClick = rgGridTypeClick
      end
    end
    object tabMesh: TTabSheet
      Caption = 'tabMesh'
      ImageIndex = 1
      TabVisible = False
      object rgMesh: TRadioGroup
        Left = 0
        Top = 0
        Width = 242
        Height = 208
        Align = alClient
        Caption = 'Data to import'
        ItemIndex = 1
        Items.Strings = (
          'Closest value to node'
          'Mean value in cell around node'
          'Highest value in cell around node'
          'Lowest value in cell around node'
          'Closest value to element center'
          'Mean value in element'
          'Highest value in element'
          'Lowest value in element'
          'All (can take a long time)')
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 250
    Height = 218
    Align = alLeft
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 144
      Width = 162
      Height = 19
      Caption = 'Grid or Mesh Layer Name'
    end
    object Label2: TLabel
      Left = 8
      Top = 80
      Width = 103
      Height = 19
      Caption = 'Parameter Name'
    end
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 109
      Height = 19
      Caption = 'Data Layer Name'
    end
    object comboGridOrMeshLayer: TComboBox
      Left = 8
      Top = 168
      Width = 233
      Height = 27
      Style = csDropDownList
      ItemHeight = 19
      TabOrder = 2
      OnChange = comboGridOrMeshLayerChange
    end
    object comboParameterNames: TComboBox
      Left = 8
      Top = 104
      Width = 233
      Height = 27
      ItemHeight = 19
      TabOrder = 1
    end
    object comboLayers: TComboBox
      Left = 8
      Top = 40
      Width = 233
      Height = 27
      ItemHeight = 19
      TabOrder = 0
      Text = 'Data'
      OnChange = comboLayersChange
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 218
    Width = 500
    Height = 107
    Align = alBottom
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 63
      Height = 19
      Caption = 'File Name'
    end
    object edFileName: TEdit
      Left = 80
      Top = 8
      Width = 313
      Height = 27
      Color = clRed
      TabOrder = 0
      OnChange = edFileNameChange
    end
    object Progress: TProgressBar
      Left = 8
      Top = 40
      Width = 466
      Height = 25
      Step = 1
      TabOrder = 2
    end
    object BitBtn3: TBitBtn
      Left = 240
      Top = 71
      Width = 75
      Height = 25
      TabOrder = 3
      Kind = bkHelp
    end
    object BitBtn2: TBitBtn
      Left = 320
      Top = 71
      Width = 75
      Height = 25
      TabOrder = 4
      Kind = bkCancel
    end
    object BitBtn1: TBitBtn
      Left = 400
      Top = 71
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 5
      OnClick = BitBtn1Click
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object btnBrowse: TBitBtn
      Left = 399
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Browse'
      TabOrder = 1
      OnClick = btnBrowseClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
        07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
        0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
    end
  end
  object odRasterFileDialog: TOpenDialog
    Filter = 'Text Files|*.txt|All Files|*.*'
    Title = 'Open Raster File'
    Left = 144
    Top = 224
  end
end
