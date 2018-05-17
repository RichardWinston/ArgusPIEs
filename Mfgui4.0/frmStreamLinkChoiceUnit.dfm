inherited frmStreamLinkChoice: TfrmStreamLinkChoice
  Left = 502
  Top = 323
  Width = 407
  Height = 124
  Caption = 'frmStreamLinkChoice'
  Font.Height = -16
  Font.Name = 'Times New Roman'
  PixelsPerInch = 96
  TextHeight = 19
  object rgChoice: TRadioGroup
    Left = 8
    Top = 8
    Width = 385
    Height = 49
    Caption = 'Choose the package for which you wish to link streams'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Stream (STR)'
      'Streamflow Routing (SFR)')
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 320
    Top = 64
    Width = 75
    Height = 25
    Caption = '&Done'
    TabOrder = 1
    Kind = bkClose
  end
end
