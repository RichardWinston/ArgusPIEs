object frmDataPosition: TfrmDataPosition
  Left = 213
  Top = 116
  Width = 273
  Height = 234
  Caption = 'Data Position'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 17
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 265
    Height = 166
    ActivePage = tabGrid
    Align = alClient
    TabOrder = 0
    object tabGrid: TTabSheet
      Caption = 'tabGrid'
      TabVisible = False
      object rgGrid: TRadioGroup
        Left = 0
        Top = 0
        Width = 257
        Height = 156
        Align = alClient
        Caption = 'Data to import'
        ItemIndex = 1
        Items.Strings = (
          'Closest value to block nodal point'
          'Mean value in block'
          'Highest elevation in block'
          'Lowest elevation in block')
        TabOrder = 0
      end
    end
    object tabMesh: TTabSheet
      Caption = 'tabMesh'
      ImageIndex = 1
      TabVisible = False
      object rgMesh: TRadioGroup
        Left = 0
        Top = 0
        Width = 257
        Height = 156
        Align = alClient
        Caption = 'Data to import'
        ItemIndex = 1
        Items.Strings = (
          'Closest value to node'
          'Mean value in cell around node'
          'Highest elevation in cell around node'
          'Lowest elevation in cell around node'
          'Closes value to element center'
          'Mean value in element'
          'Highest elevation in element'
          'Lowest elevation in element')
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 166
    Width = 265
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 104
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
