inherited frmProject: TfrmProject
  Width = 210
  Height = 121
  Caption = 'frmProject'
  PixelsPerInch = 96
  TextHeight = 14
  object ArgusDataEntry1: TArgusDataEntry
    Left = 40
    Top = 24
    Width = 145
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    Text = '0'
    DataType = dtInteger
    Max = 1
    ChangeDisabledColor = True
  end
  object BitBtn1: TBitBtn
    Left = 112
    Top = 56
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 24
    Top = 56
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object atest: TPopupMenu
    Left = 16
    Top = 16
    object test11: TMenuItem
      Caption = 'test1'
      OnClick = test11Click
    end
    object test21: TMenuItem
      Caption = 'test2'
      OnClick = test11Click
    end
  end
end
