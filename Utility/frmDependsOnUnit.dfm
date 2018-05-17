inherited frmDependsOn: TfrmDependsOn
  HelpContext = 285
  Caption = 'Layer Dependencies'
  ClientHeight = 444
  ClientWidth = 669
  Font.Height = -16
  Font.Name = 'Times New Roman'
  HelpFile = 'Utility.hlp'
  OnResize = FormResize
  ExplicitWidth = 687
  ExplicitHeight = 489
  PixelsPerInch = 120
  TextHeight = 19
  object Panel8: TPanel
    Left = 0
    Top = 403
    Width = 669
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      669
      41)
    object BitBtn1: TBitBtn
      Left = 584
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkClose
    end
    object BitBtn2: TBitBtn
      Left = 504
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkHelp
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 669
    Height = 403
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 312
      Top = 0
      Height = 403
      ExplicitHeight = 421
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 312
      Height = 403
      Align = alLeft
      TabOrder = 0
      object tvLayerStructure: TTreeView
        Left = 1
        Top = 25
        Width = 310
        Height = 377
        Align = alClient
        Indent = 21
        ReadOnly = True
        TabOrder = 1
        OnChange = tvLayerStructureChange
        OnCustomDrawItem = tvLayerStructureCustomDrawItem
      end
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 310
        Height = 24
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Layer Structure'
        TabOrder = 0
      end
    end
    object Panel3: TPanel
      Left = 315
      Top = 0
      Width = 354
      Height = 403
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Splitter2: TSplitter
        Left = 0
        Top = 183
        Width = 354
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 201
        ExplicitWidth = 364
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 354
        Height = 183
        Align = alClient
        TabOrder = 0
        object Panel6: TPanel
          Left = 1
          Top = 1
          Width = 352
          Height = 24
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Parameters that depend on the selected layer'
          TabOrder = 0
        end
        object lvDependents: TListView
          Left = 1
          Top = 25
          Width = 352
          Height = 157
          Align = alClient
          Columns = <
            item
              AutoSize = True
              Caption = 'Layer.Parameter'
            end>
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ReadOnly = True
          ParentFont = False
          TabOrder = 1
          ViewStyle = vsReport
          OnCustomDrawItem = lvDependentsCustomDrawItem
          OnSelectItem = lvDependentsSelectItem
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 186
        Width = 354
        Height = 217
        Align = alBottom
        TabOrder = 1
        object Panel7: TPanel
          Left = 1
          Top = 1
          Width = 352
          Height = 24
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Expression of the selected parameter'
          TabOrder = 0
        end
        object reExpression: TRichEdit
          Left = 1
          Top = 25
          Width = 352
          Height = 191
          Align = alClient
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
  end
end
