object frmProgress: TfrmProgress
  Left = 283
  Top = 228
  Caption = 'Export Progress'
  ClientHeight = 304
  ClientWidth = 719
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 19
  object Label1: TLabel
    Left = 8
    Top = 4
    Width = 115
    Height = 19
    Caption = 'Overall Progress'
  end
  object Label2: TLabel
    Left = 192
    Top = 23
    Width = 121
    Height = 19
    Caption = 'Current Package: '
  end
  object Label3: TLabel
    Left = 8
    Top = 52
    Width = 167
    Height = 19
    Caption = 'Progress within Package'
  end
  object Label4: TLabel
    Left = 192
    Top = 71
    Width = 111
    Height = 19
    Caption = 'Current activity:'
  end
  object Label5: TLabel
    Left = 8
    Top = 92
    Width = 161
    Height = 19
    Caption = 'Progress within activity'
  end
  object lblPackage: TLabel
    Left = 312
    Top = 23
    Width = 74
    Height = 19
    Caption = 'lblPackage'
  end
  object lblActivity: TLabel
    Left = 312
    Top = 71
    Width = 72
    Height = 19
    Caption = 'lblActivity'
  end
  object Label6: TLabel
    Left = 8
    Top = 136
    Width = 190
    Height = 19
    Caption = 'Error and warning messages'
  end
  object pbOverall: TProgressBar
    Left = 8
    Top = 24
    Width = 166
    Height = 16
    Step = 1
    TabOrder = 0
  end
  object pbPackage: TProgressBar
    Left = 8
    Top = 72
    Width = 166
    Height = 16
    Step = 1
    TabOrder = 1
  end
  object pbActivity: TProgressBar
    Left = 8
    Top = 112
    Width = 625
    Height = 16
    Step = 1
    TabOrder = 3
  end
  object BitBtn1: TBitBtn
    Left = 640
    Top = 104
    Width = 75
    Height = 25
    TabOrder = 2
    OnClick = BitBtn1Click
    Kind = bkAbort
  end
  object sbProgress: TStatusBar
    Left = 0
    Top = 285
    Width = 719
    Height = 19
    Panels = <
      item
        Text = 'Elapsed time'
        Width = 365
      end
      item
        Text = 'Estimated time remaining:'
        Width = 50
      end>
    ParentFont = True
    UseSystemFont = False
  end
  object reErrors: TRichEdit
    Left = 0
    Top = 161
    Width = 719
    Height = 124
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 360
  end
end
