object RunForm: TRunForm
  Left = 319
  Top = 179
  Width = 404
  Height = 314
  Caption = 'Run HST3D'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 160
    Width = 57
    Height = 14
    Caption = 'HST3D Path'
  end
  object Label2: TLabel
    Left = 8
    Top = 224
    Width = 68
    Height = 14
    Caption = 'BCFLOW Path'
  end
  object btnRun: TButton
    Left = 280
    Top = 48
    Width = 89
    Height = 25
    Caption = 'Export'
    TabOrder = 0
    OnClick = btnRunClick
  end
  object rgRunChoice: TRadioGroup
    Left = 8
    Top = 8
    Width = 265
    Height = 105
    Caption = 'Export Choice'
    ItemIndex = 1
    Items.Strings = (
      'Create HST3D input files'
      'Create HST3D input files and run HST3D'
      'Create BCFLOW input files'
      'Create BCFLOW input files and run BCFLOW')
    TabOrder = 1
    OnClick = rgRunChoiceClick
  end
  object BitBtn1: TBitBtn
    Left = 280
    Top = 16
    Width = 89
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object btnBrowse: TButton
    Left = 280
    Top = 144
    Width = 89
    Height = 25
    Caption = 'Browse'
    TabOrder = 3
    OnClick = btnBrowseClick
  end
  object btnEdParam: TButton
    Left = 280
    Top = 112
    Width = 89
    Height = 25
    Caption = 'Edit Parameters'
    TabOrder = 4
    OnClick = btnEdParamClick
  end
  object edRunPath: TEdit
    Left = 8
    Top = 176
    Width = 361
    Height = 22
    TabOrder = 5
    Text = 'C:\Program Files\Argus Interware\ARGUSPIE\HST3D_GUI\hst3d.exe'
    OnChange = edRunPathChange
  end
  object edBCFLOWPath: TEdit
    Left = 8
    Top = 240
    Width = 361
    Height = 22
    TabOrder = 6
    Text = 'C:\Program Files\Argus Interware\ARGUSPIE\HST3D_GUI\bcflow.exe'
    OnChange = edBCFLOWPathChange
  end
  object btnBrowseBCFLOW: TButton
    Left = 280
    Top = 208
    Width = 89
    Height = 25
    Caption = 'Browse'
    TabOrder = 7
    OnClick = btnBrowseBCFLOWClick
  end
  object BitBtn2: TBitBtn
    Left = 280
    Top = 80
    Width = 89
    Height = 25
    Caption = '&Help'
    TabOrder = 8
    OnClick = BitBtn2Click
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
  object cbPauseDos: TCheckBox
    Left = 8
    Top = 120
    Width = 177
    Height = 17
    Caption = 'Pause when done'
    Checked = True
    State = cbChecked
    TabOrder = 9
    OnClick = cbPauseDosClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'executables|*.exe|batch files|*.bat|All files|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofFileMustExist, ofOldStyleDialog, ofEnableSizing]
    Left = 240
    Top = 128
  end
end
