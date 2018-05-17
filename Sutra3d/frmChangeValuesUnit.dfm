inherited frmChangeValues: TfrmChangeValues
  Width = 591
  Height = 311
  Caption = 'Change to Recommended Default Values'
  Font.Height = -16
  PixelsPerInch = 96
  TextHeight = 18
  object clbValuesToChange: TCheckListBox
    Left = 0
    Top = 0
    Width = 583
    Height = 233
    Align = alClient
    ItemHeight = 18
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 233
    Width = 583
    Height = 44
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      583
      44)
    object btnOK: TBitBtn
      Left = 496
      Top = 8
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      TabOrder = 0
      OnClick = btnOKClick
      Kind = bkOK
    end
    object btnCancel: TBitBtn
      Left = 408
      Top = 8
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
