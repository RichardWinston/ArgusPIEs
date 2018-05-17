object frmPasteContours: TfrmPasteContours
  Left = 638
  Top = 130
  HelpContext = 225
  Caption = 'Choose Layers for Pasting Contours'
  ClientHeight = 317
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 20
  object Panel1: TPanel
    Left = 0
    Top = 273
    Width = 358
    Height = 44
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 337
    DesignSize = (
      358
      44)
    object BitBtn1: TBitBtn
      Left = 278
      Top = 9
      Width = 80
      Height = 26
      Anchors = [akRight, akBottom]
      TabOrder = 3
      OnClick = BitBtn1Click
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 195
      Top = 9
      Width = 78
      Height = 26
      Anchors = [akRight, akBottom]
      TabOrder = 2
      Kind = bkCancel
    end
    object BitBtn3: TBitBtn
      Left = 110
      Top = 9
      Width = 79
      Height = 26
      TabOrder = 1
      Kind = bkHelp
    end
    object btnAbout: TButton
      Left = 25
      Top = 9
      Width = 79
      Height = 26
      Caption = 'About'
      TabOrder = 0
    end
  end
  object clbLayerNames: TCheckListBox
    Left = 0
    Top = 0
    Width = 358
    Height = 273
    Align = alClient
    ItemHeight = 20
    TabOrder = 0
    ExplicitWidth = 337
  end
end
