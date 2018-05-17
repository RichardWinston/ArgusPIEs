object frmDataPosition: TfrmDataPosition
  Left = 213
  Top = 116
  HelpContext = 210
  Caption = 'Data Position'
  ClientHeight = 239
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 19
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 299
    Height = 165
    ActivePage = tabGrid
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 291
    object tabGrid: TTabSheet
      Caption = 'tabGrid'
      TabVisible = False
      ExplicitWidth = 283
      object rgGrid: TRadioGroup
        Left = 0
        Top = 0
        Width = 291
        Height = 155
        Align = alClient
        Caption = 'Data to import'
        ItemIndex = 1
        Items.Strings = (
          'Closest value to block nodal point'
          'Mean value in block'
          'Highest value in block'
          'Lowest value in block')
        TabOrder = 0
        ExplicitWidth = 283
      end
    end
    object tabMesh: TTabSheet
      Caption = 'tabMesh'
      ImageIndex = 1
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object rgMesh: TRadioGroup
        Left = 0
        Top = 0
        Width = 283
        Height = 155
        Align = alClient
        Caption = 'Data to import'
        ItemIndex = 1
        Items.Strings = (
          'Closest value to node'
          'Mean value in cell around node'
          'Highest value in cell around node'
          'Lowest value in cell around node'
          'Closes value to element center'
          'Mean value in element'
          'Highest value in element'
          'Lowest value in element')
        TabOrder = 0
        ExplicitWidth = 293
        ExplicitHeight = 173
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 165
    Width = 299
    Height = 74
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 291
    object BitBtn1: TBitBtn
      Left = 216
      Top = 40
      Width = 75
      Height = 25
      TabOrder = 3
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 136
      Top = 40
      Width = 75
      Height = 25
      TabOrder = 2
      Kind = bkCancel
    end
    object BitBtn3: TBitBtn
      Left = 216
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkHelp
    end
    object btnAbout: TButton
      Left = 136
      Top = 8
      Width = 75
      Height = 25
      Caption = 'About'
      TabOrder = 0
      OnClick = btnAboutClick
    end
  end
end
