object frmPostProcessingForm: TfrmPostProcessingForm
  Left = 400
  Top = 466
  Width = 602
  Height = 475
  Caption = 'Post-Processing'
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
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 594
    Height = 336
    Align = alClient
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 592
      Height = 334
      ActivePage = tabDataChoice
      Align = alClient
      TabOrder = 0
      OnChange = PageControl1Change
      object tabDataChoice: TTabSheet
        Caption = 'Data Set Choice'
        object ScrollBox1: TScrollBox
          Left = 0
          Top = 0
          Width = 584
          Height = 153
          Align = alTop
          TabOrder = 0
          object rgDataSet: TRadioGroup
            Left = 0
            Top = 0
            Width = 577
            Height = 151
            Caption = 'Preview Data Set'
            TabOrder = 0
            OnClick = rgDataSetClick
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 153
          Width = 584
          Height = 152
          Align = alClient
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
          object Panel4: TPanel
            Left = 1
            Top = 1
            Width = 582
            Height = 24
            Align = alTop
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 0
            object Label1: TLabel
              Left = 8
              Top = 4
              Width = 135
              Height = 14
              Caption = 'Plot Data Sets in Argus ONE'
            end
          end
          object clbDataSet: TCheckListBox
            Left = 1
            Top = 25
            Width = 582
            Height = 126
            Align = alClient
            ItemHeight = 14
            TabOrder = 1
          end
        end
      end
      object tabBoundary: TTabSheet
        Caption = 'Boundary Conditions'
        TabVisible = False
        object sg3dBoundary: TRBWStringGrid3d
          Left = 0
          Top = 0
          Width = 584
          Height = 304
          Align = alClient
          TabOrder = 0
          DefaultColWidth = 64
          DefaultRowHeight = 24
          FixedCol = 1
          FixedRow = 1
          GridColCount = 5
          GridRowCount = 5
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect]
        end
      end
      object tabGrid: TTabSheet
        Caption = 'Grid Configuration'
        TabVisible = False
        object sgGrid: TStringGrid
          Left = 0
          Top = 0
          Width = 584
          Height = 304
          Align = alClient
          ColCount = 4
          TabOrder = 0
        end
      end
      object tabData: TTabSheet
        Caption = 'Data'
        TabVisible = False
        object sg3dData: TRBWStringGrid3d
          Left = 0
          Top = 0
          Width = 584
          Height = 304
          Align = alClient
          TabOrder = 0
          DefaultColWidth = 64
          DefaultRowHeight = 24
          FixedCol = 1
          FixedRow = 1
          GridColCount = 5
          GridRowCount = 5
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect]
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 336
    Width = 594
    Height = 108
    Align = alBottom
    TabOrder = 1
    object lblWhich: TLabel
      Left = 248
      Top = 56
      Width = 64
      Height = 14
      Caption = ' Which Layer'
    end
    object btnReadData: TButton
      Left = 8
      Top = 16
      Width = 137
      Height = 25
      Caption = 'Read Data'
      TabOrder = 0
      OnClick = btnReadDataClick
    end
    object btnSave: TButton
      Left = 8
      Top = 72
      Width = 137
      Height = 25
      Caption = 'Save'
      Enabled = False
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object rgPlotDirection: TRadioGroup
      Left = 152
      Top = 8
      Width = 89
      Height = 89
      Caption = 'Plot along'
      ItemIndex = 2
      Items.Strings = (
        'Column'
        'Row'
        'Layer')
      TabOrder = 2
      OnClick = rgPlotDirectionClick
    end
    object adeWhich: TArgusDataEntry
      Left = 248
      Top = 75
      Width = 73
      Height = 22
      ItemHeight = 14
      TabOrder = 3
      Text = '1'
      DataType = dtInteger
      Max = 1
      Min = 1
      CheckMax = True
      CheckMin = True
      OnExceededBounds = adeWhichExceededBounds
      ChangeDisabledColor = True
    end
    object rgPlotType: TRadioGroup
      Left = 328
      Top = 8
      Width = 121
      Height = 89
      Caption = 'Plot Type'
      ItemIndex = 2
      Items.Strings = (
        '3D Surface'
        'Color Diagram'
        'Contour Diagram'
        'Cross Section')
      TabOrder = 4
    end
    object btnOK: TBitBtn
      Left = 456
      Top = 72
      Width = 75
      Height = 25
      TabOrder = 5
      OnClick = btnOKClick
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 456
      Top = 40
      Width = 75
      Height = 25
      TabOrder = 6
      Kind = bkCancel
    end
    object BitBtn1: TBitBtn
      Left = 456
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Help'
      TabOrder = 7
      OnClick = BitBtn1Click
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
  object OpenDialog1: TOpenDialog
    Filter = 
      'Pressure, Temp., Mass Frac. (PMap.*)|PMap.*|Potentiometric Head,' +
      ' Density (PMap2.*)|PMap2.*|X-, Y-, Z-Velocities (VMap.*)|VMap.*|' +
      'All Files (*.*)|*.*'
    Left = 216
    Top = 632
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 144
    Top = 16
  end
end
