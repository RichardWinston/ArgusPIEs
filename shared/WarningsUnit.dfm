object frmWarnings: TfrmWarnings
  Left = 213
  Top = 203
  Width = 685
  Height = 273
  Caption = 'Renamed layers and parameters'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object memoWarnings: TMemo
    Left = 0
    Top = 0
    Width = 677
    Height = 160
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 160
    Width = 677
    Height = 86
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 9
      Top = 8
      Width = 419
      Height = 38
      Caption = 
        'The above changes have been made in your project, you may need t' +
        'o update expressions to reflect these changes.'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 535
      Height = 38
      Caption = 
        'This is NOT an error message. Instead, it reflects the normal op' +
        'eration of the software in response to a change in the design of' +
        ' the layer structure. '
      WordWrap = True
    end
    object BitBtn1: TBitBtn
      Left = 592
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkOK
    end
    object btnCopy: TButton
      Left = 448
      Top = 8
      Width = 139
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Copy to clipboard'
      TabOrder = 1
      OnClick = btnCopyClick
    end
  end
end
