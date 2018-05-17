object frmUserResponse: TfrmUserResponse
  Left = 325
  Top = 238
  Caption = 'frmUserResponse'
  ClientHeight = 71
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 474
    Height = 38
    Align = alClient
    Alignment = taCenter
    Caption = 'Your Question Here.'
    WordWrap = True
    ExplicitWidth = 111
    ExplicitHeight = 15
  end
  object Panel1: TPanel
    Left = 0
    Top = 38
    Width = 474
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      474
      33)
    object adeResponse: TArgusDataEntry
      Left = 4
      Top = 5
      Width = 308
      Height = 22
      ItemHeight = 15
      TabOrder = 0
      Text = '0'
      DataType = dtReal
      Max = 1.000000000000000000
      ChangeDisabledColor = True
    end
    object BitBtn1: TBitBtn
      Left = 397
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 318
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      NumGlyphs = 2
    end
  end
end
