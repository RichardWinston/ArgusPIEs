object frmCompareBoundaries: TfrmCompareBoundaries
  Left = 249
  Top = 287
  Width = 907
  Height = 212
  Caption = 'CheckMatchBC'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 17
  object Label1: TLabel
    Left = 2
    Top = 31
    Width = 203
    Height = 17
    Caption = 'Max Relative Pressure Difference'
  end
  object Label3: TLabel
    Left = 2
    Top = 90
    Width = 313
    Height = 17
    Caption = 'Max Relative Concentration/Temperature Difference'
  end
  object Label4: TLabel
    Left = 2
    Top = 61
    Width = 199
    Height = 17
    Caption = 'Min Relative Pressure Difference'
  end
  object Label6: TLabel
    Left = 2
    Top = 120
    Width = 309
    Height = 17
    Caption = 'Min Relative Concentration/Temperature Difference'
  end
  object Label2: TLabel
    Left = 472
    Top = 8
    Width = 90
    Height = 17
    Caption = 'Node Numbers'
  end
  object Label5: TLabel
    Left = 568
    Top = 8
    Width = 93
    Height = 17
    Caption = 'Specified Value'
  end
  object Label7: TLabel
    Left = 680
    Top = 8
    Width = 101
    Height = 17
    Caption = 'Calculated Value'
  end
  object Label8: TLabel
    Left = 792
    Top = 8
    Width = 93
    Height = 17
    Caption = 'Matching Digits'
  end
  object Label9: TLabel
    Left = 0
    Top = 144
    Width = 417
    Height = 34
    Caption = 
      'Ideal selection of the GNUP and GNUU parameters in Dataset 5 cau' +
      'ses the simulated and specified values to match in six to eight ' +
      'digits.'
    WordWrap = True
  end
  object Button1: TButton
    Left = 790
    Top = 152
    Width = 99
    Height = 25
    Caption = 'Select Files'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edMaxPres: TEdit
    Left = 318
    Top = 27
    Width = 149
    Height = 25
    TabOrder = 1
    Text = '0'
  end
  object edMinPres: TEdit
    Left = 318
    Top = 57
    Width = 149
    Height = 25
    TabOrder = 2
    Text = '0'
  end
  object edMaxConc: TEdit
    Left = 318
    Top = 86
    Width = 149
    Height = 25
    TabOrder = 3
    Text = '0'
  end
  object edMinConc: TEdit
    Left = 318
    Top = 116
    Width = 149
    Height = 25
    TabOrder = 4
    Text = '0'
  end
  object edMaxPresIndex: TEdit
    Left = 470
    Top = 27
    Width = 91
    Height = 25
    TabOrder = 5
    Text = '0'
  end
  object edMinPresIndex: TEdit
    Left = 470
    Top = 57
    Width = 91
    Height = 25
    TabOrder = 6
    Text = '0'
  end
  object edMaxConcIndex: TEdit
    Left = 470
    Top = 86
    Width = 91
    Height = 25
    TabOrder = 7
    Text = '0'
  end
  object edMinConcIndex: TEdit
    Left = 470
    Top = 116
    Width = 91
    Height = 25
    TabOrder = 8
    Text = '0'
  end
  object edMaxPresSpecified: TEdit
    Left = 566
    Top = 27
    Width = 107
    Height = 25
    TabOrder = 9
    Text = '0'
  end
  object edMinPresSpecified: TEdit
    Left = 566
    Top = 57
    Width = 107
    Height = 25
    TabOrder = 10
    Text = '0'
  end
  object edMaxConcSpecified: TEdit
    Left = 566
    Top = 86
    Width = 107
    Height = 25
    TabOrder = 11
    Text = '0'
  end
  object edMinConcSpecified: TEdit
    Left = 566
    Top = 116
    Width = 107
    Height = 25
    TabOrder = 12
    Text = '0'
  end
  object edMaxPresCalculated: TEdit
    Left = 678
    Top = 27
    Width = 107
    Height = 25
    TabOrder = 13
    Text = '0'
  end
  object edMinPresCalculated: TEdit
    Left = 678
    Top = 57
    Width = 107
    Height = 25
    TabOrder = 14
    Text = '0'
  end
  object edMaxConcCalculated: TEdit
    Left = 678
    Top = 86
    Width = 107
    Height = 25
    TabOrder = 15
    Text = '0'
  end
  object edMinConcCalculated: TEdit
    Left = 678
    Top = 116
    Width = 107
    Height = 25
    TabOrder = 16
    Text = '0'
  end
  object edMaxPresDigits: TEdit
    Left = 790
    Top = 27
    Width = 99
    Height = 25
    TabOrder = 17
    Text = '0'
  end
  object edMinPresDigits: TEdit
    Left = 790
    Top = 57
    Width = 99
    Height = 25
    TabOrder = 18
    Text = '0'
  end
  object edMaxConcDigits: TEdit
    Left = 790
    Top = 86
    Width = 99
    Height = 25
    TabOrder = 19
    Text = '0'
  end
  object edMinConcDigits: TEdit
    Left = 790
    Top = 116
    Width = 99
    Height = 25
    TabOrder = 20
    Text = '0'
  end
  object btnAbout: TButton
    Left = 704
    Top = 152
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 21
    OnClick = btnAboutClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Sutra Input files (*.inp)|*.inp|All Files (*.*)|*.*'
    Title = 'Open Sutra Input File'
    Left = 8
    Top = 8
  end
  object OpenDialog2: TOpenDialog
    Filter = 'Sutra node files (*.nod)|*.nod|All Files (*.*)|*.*'
    Title = 'Open Sutra Node File'
    Left = 40
    Top = 8
  end
end
