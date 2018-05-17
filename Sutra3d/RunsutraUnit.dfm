object frmRun: TfrmRun
  Left = 388
  Top = 46
  BorderStyle = bsDialog
  Caption = 'Run SUTRA'
  ClientHeight = 690
  ClientWidth = 656
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object PageControlMain: TPageControl
    Left = 0
    Top = 0
    Width = 656
    Height = 690
    ActivePage = tabFirst
    Align = alClient
    TabOrder = 0
    object tabFirst: TTabSheet
      Caption = 'Main Options'
      object lblPath: TLabel
        Left = 8
        Top = 304
        Width = 91
        Height = 19
        Caption = 'SUTRA Path'
      end
      object lblRoot: TLabel
        Left = 144
        Top = 12
        Width = 206
        Height = 19
        Caption = 'Root file name for simulation'
      end
      object Label19: TLabel
        Left = 24
        Top = 368
        Width = 594
        Height = 19
        Caption = 
          '(This reduces the execution time of SutraGUI when not all data s' +
          'ets are exported.)'
      end
      object cbExternal: TCheckBox
        Left = 8
        Top = 280
        Width = 409
        Height = 17
        Caption = '&External calibration program running Argus ONE'
        TabOrder = 0
      end
      object rgAlert: TRadioGroup
        Left = 8
        Top = 184
        Width = 633
        Height = 81
        Caption = 'Alert level'
        ItemIndex = 0
        Items.Strings = (
          'Show &all warnings'
          'Warn &only about problems that will cause invalid model input'
          'Show &no warnings')
        TabOrder = 1
      end
      object rgRunSutra: TRadioGroup
        Left = 8
        Top = 40
        Width = 489
        Height = 137
        Caption = 'Model input'
        ItemIndex = 1
        Items.Strings = (
          'Create &SUTRA input files'
          'Create SUTRA input files and &run SUTRA'
          'Create &Template files for UCODE'
          'Create &UCODE files'
          'Create UCODE files and run inverse simulation  ')
        TabOrder = 2
        OnClick = rgRunSutraClick
      end
      object btnOK: TBitBtn
        Left = 503
        Top = 8
        Width = 138
        Height = 30
        Caption = '&OK'
        TabOrder = 3
        OnClick = btnOKClick
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 503
        Top = 44
        Width = 138
        Height = 30
        Caption = '&Cancel'
        TabOrder = 4
        Kind = bkCancel
      end
      object btnEdit: TButton
        Left = 503
        Top = 80
        Width = 138
        Height = 30
        Caption = '&Edit Params >>'
        TabOrder = 5
        OnClick = btnEditClick
      end
      object edSutraPath: TEdit
        Left = 8
        Top = 320
        Width = 489
        Height = 27
        TabOrder = 6
        Text = 'C:\SUTRA\sutra.exe'
        OnChange = edSutraPathChange
      end
      object BitBtn3: TBitBtn
        Left = 503
        Top = 318
        Width = 138
        Height = 30
        Caption = 'Browse'
        TabOrder = 7
        OnClick = btnBrowseClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
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
      object gbExport: TGroupBox
        Left = 7
        Top = 392
        Width = 634
        Height = 257
        Caption = 'Data sets to export (others are always exported)'
        TabOrder = 8
        object cbExport14B: TCheckBox
          Left = 8
          Top = 53
          Width = 521
          Height = 17
          Caption = 
            'Data Set 14B (Node locations, porosity, unsaturated flow regions' +
            ')'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbExport15B: TCheckBox
          Left = 8
          Top = 71
          Width = 617
          Height = 17
          Caption = 
            'Data Set 15B (Element unsaturated flow regions, permeability, pe' +
            'rmeability angle)'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object cbExport17: TCheckBox
          Left = 8
          Top = 90
          Width = 489
          Height = 17
          Caption = 'Data Set 17 (Fluid sources and sinks)'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object cbExport18: TCheckBox
          Left = 8
          Top = 108
          Width = 489
          Height = 17
          Caption = 'Data Set 18 (Energy or solute mass sources and sinks)'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object cbExport19: TCheckBox
          Left = 8
          Top = 126
          Width = 489
          Height = 17
          Caption = 'Data Set 19 (Specified pressures)'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object cbExport20: TCheckBox
          Left = 8
          Top = 145
          Width = 489
          Height = 17
          Caption = 'Data Set 20 (Specified concentrations or temperatures)'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object cbExport22: TCheckBox
          Left = 8
          Top = 163
          Width = 489
          Height = 17
          Caption = 'Data Set 22 (Element incidence)'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object cbExport8D: TCheckBox
          Left = 8
          Top = 34
          Width = 489
          Height = 17
          Caption = 'Data Set 8D (Observation nodes)'
          Checked = True
          State = cbChecked
          TabOrder = 7
        end
        object cbExportICS2: TCheckBox
          Left = 8
          Top = 182
          Width = 489
          Height = 17
          Caption = 'Data Set ICS 2 (Initial pressure)'
          Checked = True
          State = cbChecked
          TabOrder = 8
        end
        object cbExportICS3: TCheckBox
          Left = 8
          Top = 200
          Width = 489
          Height = 17
          Caption = 'Data Set ICS 3 (Initial temperatures or concentrations)'
          Checked = True
          State = cbChecked
          TabOrder = 9
        end
        object cbExportNBI: TCheckBox
          Left = 8
          Top = 16
          Width = 313
          Height = 17
          Caption = 'NBI: Data Set 3 (bandwidth)'
          Checked = True
          State = cbChecked
          TabOrder = 10
        end
        object btnAll: TButton
          Left = 8
          Top = 224
          Width = 49
          Height = 25
          Caption = 'All'
          TabOrder = 11
          OnClick = btnAllClick
        end
        object btnNone: TButton
          Left = 64
          Top = 224
          Width = 49
          Height = 25
          Caption = 'None'
          TabOrder = 12
          OnClick = btnAllClick
        end
      end
      object edRoot: TEdit
        Left = 8
        Top = 8
        Width = 129
        Height = 27
        TabOrder = 9
        OnChange = edRootChange
      end
      object cbSaveTempFiles: TCheckBox
        Left = 8
        Top = 352
        Width = 361
        Height = 17
        Caption = 'Save temporary files for reuse by SutraGUI.'
        TabOrder = 10
      end
    end
    object tabSecond: TTabSheet
      Caption = 'Memory options'
      ImageIndex = 1
      object gbPolyhedron: TGroupBox
        Left = 8
        Top = 0
        Width = 537
        Height = 369
        Caption = 'How should the polyhedrons around nodes be treated?'
        TabOrder = 0
        object rbMemory: TRadioButton95
          Left = 8
          Top = 16
          Width = 521
          Height = 57
          Alignment = taLeftJustify
          Caption = 
            'Compute them when creating the mesh and keep them in memory. (Fa' +
            'stest option if the model is small but very slow if the model is' +
            ' large.)'
          TabOrder = 0
          WordWrap = True
          AlignmentBtn = taLeftJustify
          LikePushButton = False
          VerticalAlignment = vaTop
        end
        object rbStore: TRadioButton95
          Left = 8
          Top = 91
          Width = 521
          Height = 86
          Alignment = taLeftJustify
          Caption = 
            'Compute them when creating the mesh and store them in a file. (S' +
            'low but if you have a big model, a lot of free disk space, and a' +
            're not changing the geometry of the mesh, you can then use the n' +
            'ext option in the future to save a little time.)'
          TabOrder = 1
          WordWrap = True
          AlignmentBtn = taLeftJustify
          LikePushButton = False
          VerticalAlignment = vaTop
        end
        object rbRead: TRadioButton95
          Left = 8
          Top = 186
          Width = 521
          Height = 79
          Alignment = taLeftJustify
          Caption = 
            'Read them from an existing file.  (You should only choose this o' +
            'ption if none of  the node positions have changed since the last' +
            ' time the node positions were saved.) (This option may save some' +
            ' time for some large models.)'
          Enabled = False
          TabOrder = 2
          WordWrap = True
          AlignmentBtn = taLeftJustify
          LikePushButton = False
          VerticalAlignment = vaTop
        end
        object rbCompute: TRadioButton95
          Left = 8
          Top = 272
          Width = 521
          Height = 89
          Alignment = taLeftJustify
          Caption = 
            'Compute polyhedrons each time they are needed. (This option invo' +
            'lves some extra computation but it saves a lot of memory and dis' +
            'k space.  Because of these savings, it is usually the fastest op' +
            'tion.)'
          Checked = True
          TabOrder = 3
          TabStop = True
          WordWrap = True
          AlignmentBtn = taLeftJustify
          LikePushButton = False
          VerticalAlignment = vaTop
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'inp'
    Filter = 'input files (*.inp)|*.inp|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 448
    Top = 200
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Executable files (*.exe;*.bat)|*.exe;*.bat|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 416
    Top = 200
  end
end
