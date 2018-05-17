object frmModflowImport: TfrmModflowImport
  Left = 468
  Top = 207
  Caption = 'Modflow Import'
  ClientHeight = 502
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 546
    Height = 469
    ActivePage = tabWarning2
    Align = alClient
    TabOrder = 0
    OnChange = pcMainChange
    object tabInitial: TTabSheet
      Caption = 'tabInitial'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 535
        Height = 192
        Align = alClient
        Caption = 
          'Warning: If an error occurs when importing a model, Argus ONE ma' +
          'y be shut down without warning.  All your unsaved work could be ' +
          'lost.  To avoid this you should save your work before continuing' +
          '.  If you have not yet saved your work, click on the Quit button' +
          ', save your work, and then return here.'#13#10#13#10'You can only import d' +
          'ata for USGS MODFLOW packages using this procedure.  You can not' +
          ' import data for MOC3D, GWT or for non USGS packages.'#13#10#13#10'If any ' +
          'of the input files for your model are binary files, they must be' +
          ' files that are compatible with the Lahey LF90 Fortran compiler.' +
          '  Any binary files that are output files must be deleted before ' +
          'attempting to import the model if the binary files are not compa' +
          'tible with the Lahey LF90 Fortran compiler.'
        WordWrap = True
      end
    end
    object tabWarning2: TTabSheet
      Caption = 'tabWarning2'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 538
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label19: TLabel
          Left = 0
          Top = 0
          Width = 468
          Height = 16
          Align = alTop
          Caption = 
            'More Warnings: All of the input files for your model must be in ' +
            'the same directory.'
          WordWrap = True
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 33
        Width = 538
        Height = 48
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label21: TLabel
          Left = 0
          Top = 0
          Width = 520
          Height = 32
          Align = alTop
          Caption = 
            'The output file for the model specified in the name file will be' +
            ' overwritten in the process of importing the model. '
          WordWrap = True
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 81
        Width = 538
        Height = 64
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Label22: TLabel
          Left = 0
          Top = 0
          Width = 515
          Height = 48
          Align = alTop
          Caption = 
            'Some non-USGS versions of MODFLOW support methods for reading ar' +
            'rays that are not supported by the USGS version of MODFLOW (or t' +
            'he MODFLOW GUI).  Input files for such models must be converted ' +
            'to the standard format before they can be imported. '
          WordWrap = True
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 145
        Width = 538
        Height = 56
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 3
        object Label23: TLabel
          Left = 0
          Top = 0
          Width = 524
          Height = 48
          Align = alTop
          Caption = 
            'Unit numbers of 1, 5, or 6 in the name file will cause Argus ONE' +
            ' to crash when importing.  Change those unit numbers to some oth' +
            'er, unused unit numbers before attempting to import the model.'
          WordWrap = True
        end
      end
    end
    object tabConvert: TTabSheet
      Caption = 'tabConvert'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label20: TLabel
        Left = 0
        Top = 0
        Width = 538
        Height = 112
        Align = alClient
        Caption = 
          'If the input files are transferred from a UNIX computer to a per' +
          'sonal computer, the symbols used to mark the end of lines may no' +
          't be correct for use on a PC.  If that is the case, click the "S' +
          'elect Files" button and select any ASCII input files for your mo' +
          'del.  They will be converted to use the correct line terminators' +
          ' for a personal computer.  This change is permanent and can not ' +
          'be cancelled.  The modified files will not be useable on a UNIX ' +
          'machine unless the files are converted back to using UNIX line t' +
          'erminators.  Therefore, it is a good idea to back-up any files y' +
          'ou are using before performing this operation on them. '
        WordWrap = True
      end
      object Button1: TButton
        Left = 8
        Top = 160
        Width = 75
        Height = 25
        Caption = 'Select Files'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
    object tabModelChoice: TTabSheet
      Caption = 'tabModelChoice'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 367
        Height = 16
        Caption = 'Choose the type of MODFLOW model you are trying to import. '
      end
      object Label13: TLabel
        Left = 8
        Top = 120
        Width = 216
        Height = 112
        Caption = 
          'If you choose a MODFLOW-88 model, this program will help you cre' +
          'ate a name file for a MODFLOW-96 model. Otherwise, you will just' +
          ' choose the MODFLOW-96 or MODFLOW-2000 name file.'
        WordWrap = True
      end
      object rgModelType: TRadioGroup
        Left = 8
        Top = 27
        Width = 155
        Height = 78
        Caption = 'Model Type'
        ItemIndex = 0
        Items.Strings = (
          'MODFLOW-88'
          'MODFLOW-96'
          'MODFLOW-2000')
        TabOrder = 0
      end
    end
    object tabNameFile: TTabSheet
      Caption = 'tabNameFile'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 264
        Height = 16
        Caption = 'Which version of MODFLOW-88  did you use'
      end
      object rgPreprocessor: TRadioGroup
        Left = 8
        Top = 23
        Width = 177
        Height = 194
        Caption = 'Modflow version used'
        ItemIndex = 0
        Items.Strings = (
          'USGS'
          'Kerr Lab'
          'MODFLOW386'
          'Visual MODFLOW'
          'GMS'
          'Processing MODFLOW'
          'IGWMC'
          'S. S. Papadopulos'
          'Groundwater Vistas'
          'Other or don'#39't know')
        TabOrder = 0
        OnClick = rgPreprocessorClick
      end
    end
    object tabIUNIT: TTabSheet
      Caption = 'tabIUNIT'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 260
        Height = 112
        Caption = 
          'The structure of the IUNIT array is important in the internal op' +
          'eration of MODFLOW-88.  Consult the documentation for your versi' +
          'on of MODFLOW to determine the structure of the IUNIT array in t' +
          'he version of MODFLOW for which this model was originally design' +
          'ed. '
        WordWrap = True
      end
      object Label5: TLabel
        Left = 8
        Top = 75
        Width = 269
        Height = 64
        Caption = 
          'If you chose a specific version of MODFLOW in the previous step,' +
          ' the IUNIT array structure shown below is probably correct but y' +
          'ou should check it just to make sure.'
        WordWrap = True
      end
      object Label14: TLabel
        Left = 8
        Top = 121
        Width = 268
        Height = 80
        Caption = 
          'When you click the "Next" button, you will be prompted to select' +
          ' the input file for the Basic package.  This file will be read a' +
          'nd used to determine which packages were included in the model y' +
          'ou are trying to import.'
        WordWrap = True
      end
      object dgIUNIT: TDataGrid
        Left = 0
        Top = 378
        Width = 538
        Height = 60
        Align = alBottom
        ColCount = 24
        DefaultColWidth = 45
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
        TabOrder = 0
        Columns = <
          item
            LimitToList = True
            DropDownRows = 10
            PickList.Strings = (
              'OC'
              'BCF'
              'RCH'
              'RIV'
              'WIL'
              'DRN'
              'GHB'
              'EVT'
              'SIP'
              'SOR'
              'TLK'
              'DE4'
              'GFD'
              'HFB'
              'RES'
              'STR'
              'IBS'
              'CHD'
              'FHB'
              'None')
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            LimitToList = True
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            Title.Alignment = taCenter
            Title.WordWrap = False
          end
          item
            Title.Alignment = taCenter
            Title.WordWrap = False
          end>
        RowCountMin = 0
        SelectedIndex = 0
        Version = '2.0'
      end
      object Panel3: TPanel
        Left = 0
        Top = 361
        Width = 538
        Height = 17
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'IUNIT Array structure'
        TabOrder = 1
      end
    end
    object tabCreateNameFile: TTabSheet
      Caption = 'tabCreateNameFile'
      ImageIndex = 4
      OnShow = tabCreateNameFileShow
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblNFiles: TLabel
        Left = 188
        Top = 90
        Width = 185
        Height = 16
        Caption = 'Number of input and output files'
      end
      object Label6: TLabel
        Left = 8
        Top = 8
        Width = 211
        Height = 80
        Caption = 
          'The next step is to create a MODFLOW-96 name file for your model' +
          '.  Click the button below to choose the name and directory of th' +
          'e name file.'
        WordWrap = True
      end
      object Label7: TLabel
        Left = 8
        Top = 112
        Width = 64
        Height = 16
        Caption = 'Name File: '
      end
      object Label18: TLabel
        Left = 8
        Top = 156
        Width = 317
        Height = 128
        Caption = 
          'Originally MODFLOW used Nunit = 1 as the unit on which the Basic' +
          ' file was read.  Later that was changed to Nunit = 5.  Be sure t' +
          'o check the Basic package input file to determine which unit num' +
          'ber was used in the model you are trying to import and use the c' +
          'orrect number in the name file.  The unit number will be the fir' +
          'st number in an array control record before an array is read.'
        WordWrap = True
      end
      object dgNameFile: TDataGrid
        Left = 0
        Top = 311
        Width = 538
        Height = 127
        Align = alBottom
        ColCount = 3
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 3
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
        TabOrder = 0
        OnSetEditText = dgNameFileSetEditText
        Columns = <
          item
            LimitToList = True
            PickList.Strings = (
              'LIST'
              'BAS'
              'OC'
              'BCF'
              'RCH'
              'RIV'
              'WEL'
              'DRN'
              'GHB'
              'EVT'
              'SIP'
              'SOR'
              'TLK'
              'DE4'
              'GFD'
              'HFB'
              'RES'
              'STR'
              'IBS'
              'CHD'
              'FHB'
              'DATA(BINARY)'
              'DATA')
            Title.Caption = 'Ftype'
            Title.WordWrap = False
          end
          item
            Alignment = taCenter
            Format = cfNumber
            Title.Caption = 'Nunit'
            Title.WordWrap = False
          end
          item
            ButtonStyle = cbsEllipsis
            Title.Caption = 'Fname'
            Title.WordWrap = False
          end>
        RowCountMin = 0
        OnEditButtonClick = dgNameFileEditButtonClick
        SelectedIndex = 0
        Version = '2.0'
        ColWidths = (
          64
          64
          274)
      end
      object btnNameFileCreate: TButton
        Left = 8
        Top = 87
        Width = 113
        Height = 21
        Caption = 'Create Name File'
        TabOrder = 1
        OnClick = btnNameFileCreateClick
      end
      object adeNFiles: TArgusDataEntry
        Left = 140
        Top = 88
        Width = 34
        Height = 18
        ItemHeight = 0
        TabOrder = 2
        Text = '2'
        OnChange = adeNFilesChange
        DataType = dtInteger
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object edName: TEdit
        Left = 83
        Top = 109
        Width = 446
        Height = 24
        TabOrder = 3
        OnChange = edNameChange
      end
      object Panel2: TPanel
        Left = 0
        Top = 279
        Width = 538
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 4
        object Label15: TLabel
          Left = 5
          Top = 1
          Width = 214
          Height = 64
          Caption = 
            'To select the input file for a package, select the cell for that' +
            ' package under "Fname" and click the button in the cell.'
          WordWrap = True
        end
      end
    end
    object tabSelectNameFile: TTabSheet
      Caption = 'tabSelectNameFile'
      ImageIndex = 5
      OnShow = EdNameDuplicateChange
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label8: TLabel
        Left = 8
        Top = 37
        Width = 64
        Height = 16
        Caption = 'Name File: '
      end
      object EdNameDuplicate: TEdit
        Left = 6
        Top = 54
        Width = 523
        Height = 24
        TabOrder = 0
        OnChange = EdNameDuplicateChange
      end
      object btnSelectNameFile: TButton
        Left = 8
        Top = 8
        Width = 121
        Height = 20
        Caption = 'Select Name File'
        TabOrder = 1
        OnClick = btnSelectNameFileClick
      end
    end
    object tabModelProperties: TTabSheet
      Caption = 'tabModelProperties'
      ImageIndex = 6
      OnShow = tabModelPropertiesShow
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 131
        Top = 61
        Width = 60
        Height = 16
        Caption = 'Grid Angle'
      end
      object Label10: TLabel
        Left = 131
        Top = 81
        Width = 49
        Height = 16
        Caption = 'Origin X'
      end
      object Label11: TLabel
        Left = 131
        Top = 102
        Width = 47
        Height = 16
        Caption = 'Origin Y'
      end
      object Label12: TLabel
        Left = 8
        Top = 8
        Width = 505
        Height = 32
        Caption = 
          'Set the location of the origin of the grid and the angle the gri' +
          'd makes with the horizontal. The origin of the grid is the corne' +
          'r of the grid closest to row 1, column 1.'
        WordWrap = True
      end
      object Label16: TLabel
        Left = 8
        Top = 170
        Width = 316
        Height = 96
        Caption = 
          'When you click the "Finish" button, the input files for the MODF' +
          'LOW model will be read and the data will be imported into Argus ' +
          'ONE.  This can take a while so please be patient.  If you haven'#39 +
          't saved your work, this is your last chance to save it before th' +
          'e import process begins.  '
        WordWrap = True
      end
      object Label17: TLabel
        Left = 8
        Top = 301
        Width = 268
        Height = 48
        Caption = 
          'Warning: If anything goes wrong with the import process, Argus m' +
          'ay be shut down prematurely. '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object adeGridAngle: TArgusDataEntry
        Left = 8
        Top = 58
        Width = 113
        Height = 19
        ItemHeight = 0
        TabOrder = 0
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeOrX: TArgusDataEntry
        Left = 8
        Top = 79
        Width = 113
        Height = 17
        ItemHeight = 0
        TabOrder = 1
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object adeOrY: TArgusDataEntry
        Left = 8
        Top = 99
        Width = 113
        Height = 18
        ItemHeight = 0
        TabOrder = 2
        Text = '0'
        DataType = dtReal
        Max = 1.000000000000000000
        ChangeDisabledColor = True
      end
      object cbRowsPositive: TCheckBox95
        Left = 8
        Top = 121
        Width = 309
        Height = 24
        Alignment = taLeftJustify
        Caption = 'Row numbers increase upward (usually false)'
        TabOrder = 3
        WordWrap = False
        AlignmentBtn = taLeftJustify
        LikePushButton = False
        VerticalAlignment = vaTop
      end
      object cbColumnsPositive: TCheckBox95
        Left = 8
        Top = 143
        Width = 329
        Height = 26
        Alignment = taLeftJustify
        Caption = 'Columns numbers increase to the right (usually true)'
        Checked = True
        State = cbChecked
        TabOrder = 4
        WordWrap = False
        AlignmentBtn = taLeftJustify
        LikePushButton = False
        VerticalAlignment = vaTop
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 469
    Width = 546
    Height = 33
    Align = alBottom
    TabOrder = 1
    object btnNext: TBitBtn
      Left = 312
      Top = 5
      Width = 62
      Height = 23
      Caption = '&Next'
      TabOrder = 0
      OnClick = btnNextClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      Layout = blGlyphRight
      NumGlyphs = 2
    end
    object btnBack: TBitBtn
      Left = 244
      Top = 5
      Width = 63
      Height = 23
      Caption = '&Back'
      Enabled = False
      TabOrder = 1
      OnClick = btnBackClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object btnCancel: TBitBtn
      Left = 177
      Top = 5
      Width = 62
      Height = 23
      Caption = '&Quit'
      TabOrder = 2
      Kind = bkCancel
    end
    object BitBtn1: TBitBtn
      Left = 109
      Top = 5
      Width = 64
      Height = 23
      HelpContext = 1580
      TabOrder = 3
      Kind = bkHelp
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Name Files (*.nam;*.in)|*.nam;*.in|All Files (*.*)|*.*'
    Left = 8
    Top = 475
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 40
    Top = 476
  end
  object OpenDialog2: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = 'Select UNIX-style ASCII files'
    Left = 72
    Top = 476
  end
end
