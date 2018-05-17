object frmPostSutra: TfrmPostSutra
  Left = 422
  Top = 442
  BorderStyle = bsDialog
  Caption = 'Select SUTRA results to display'
  ClientHeight = 335
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    605
    335)
  PixelsPerInch = 120
  TextHeight = 19
  object lvResult: TListView
    Left = 0
    Top = 0
    Width = 505
    Height = 217
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Time Step'
        Width = 100
      end
      item
        Alignment = taCenter
        Caption = 'Head'
        Width = 90
      end
      item
        Alignment = taCenter
        Caption = 'Concentration'
        Width = 120
      end
      item
        Alignment = taCenter
        Caption = 'Saturation'
        Width = 100
      end
      item
        Alignment = taCenter
        Caption = 'Velocity'
        Width = 80
      end>
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvResultColumnClick
    OnMouseUp = lvResultMouseUp
  end
  object BitBtn1: TBitBtn
    Left = 512
    Top = 8
    Width = 83
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 512
    Top = 40
    Width = 83
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 2
    Kind = bkCancel
  end
  object rgChartArrangement: TRadioGroup
    Left = 8
    Top = 230
    Width = 593
    Height = 99
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Chart Arrangement'
    ItemIndex = 2
    Items.Strings = (
      'Tile charts separately on a single layer'
      'Overlay charts for each time step, tile on a single layer'
      'Overlay mesh for all charts')
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Sutra Output files (*.nod, *.ele)|*.nod;*.ele|All Files (*.*)|*.' +
      '*'
    Left = 448
    Top = 96
  end
end
