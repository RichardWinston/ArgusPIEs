object Form1: TForm1
  Left = 309
  Top = 124
  Width = 519
  Height = 252
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 312
    Top = 128
    Width = 34
    Height = 16
    Caption = 'Layer'
  end
  inline framFilePath1: TframFilePath
    Left = 8
    Top = 8
    inherited lblFileType: TLabel
      Width = 158
      Caption = 'Configuration file File Type'
    end
    inherited OpenDialogPath: TOpenDialog
      Filter = '*.cnf|*.cnf'
    end
  end
  inline framFilePath2: TframFilePath
    Left = 8
    Top = 56
    TabOrder = 1
    inherited lblFileType: TLabel
      Width = 102
      Caption = 'Concentration file'
    end
    inherited OpenDialogPath: TOpenDialog
      Filter = '*.ucn|*.ucn'
    end
  end
  object Button1: TButton
    Left = 16
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 104
    Top = 120
    Width = 121
    Height = 24
    TabOrder = 3
    Text = 'Edit1'
  end
  object Memo1: TMemo
    Left = 376
    Top = 112
    Width = 105
    Height = 33
    TabOrder = 4
    WordWrap = False
  end
  object SpinEdit1: TSpinEdit
    Left = 240
    Top = 120
    Width = 65
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 1
  end
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 160
    Width = 497
    Height = 57
    ItemHeight = 16
    TabOrder = 6
  end
end
