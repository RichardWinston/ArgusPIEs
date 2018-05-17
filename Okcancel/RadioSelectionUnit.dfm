object frmRadio: TfrmRadio
  Left = 192
  Top = 136
  Caption = 'Choose one'
  ClientHeight = 229
  ClientWidth = 642
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object pnlBottom: TPanel
    Left = 0
    Top = 192
    Width = 642
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      642
      37)
    object btnOK: TBitBtn
      Left = 555
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      NumGlyphs = 2
    end
    object btnCancel: TButton
      Left = 474
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
  end
  object rgChoices: TRadioGroup
    Left = 0
    Top = 41
    Width = 642
    Height = 151
    Align = alClient
    Caption = 'Make your Selection'
    TabOrder = 1
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 642
    Height = 41
    Align = alTop
    Alignment = taRightJustify
    BevelOuter = bvNone
    TabOrder = 0
    object lblQuestion: TLabel
      Left = 0
      Top = 0
      Width = 642
      Height = 41
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'Your Question Here.'
      WordWrap = True
      ExplicitWidth = 652
    end
  end
end
