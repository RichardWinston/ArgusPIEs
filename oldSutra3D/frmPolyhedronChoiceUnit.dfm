object frmPolyhedronChoice: TfrmPolyhedronChoice
  Left = 190
  Top = 389
  Width = 359
  Height = 232
  Caption = 'Polyhedron Storage Choice'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 16
  object gbPolyhedron: TGroupBox
    Left = 8
    Top = 0
    Width = 337
    Height = 169
    Caption = 'How should the polyhedrons around nodes be treated?'
    TabOrder = 0
    object rbMemory: TRadioButton95
      Left = 8
      Top = 16
      Width = 321
      Height = 33
      Alignment = taLeftJustify
      Caption = 'Compute them when creating the mesh and keep them in memory'
      TabOrder = 0
      AlignmentBtn = taLeftJustify
      LikePushButton = False
      VerticalAlignment = vaTop
      WordWrap = True
    end
    object rbStore: TRadioButton95
      Left = 8
      Top = 48
      Width = 321
      Height = 33
      Alignment = taLeftJustify
      Caption = 'Compute them when creating the mesh and store them in a file'
      TabOrder = 1
      AlignmentBtn = taLeftJustify
      LikePushButton = False
      VerticalAlignment = vaTop
      WordWrap = True
    end
    object rbRead: TRadioButton95
      Left = 8
      Top = 80
      Width = 321
      Height = 65
      Alignment = taLeftJustify
      Caption = 
        'Read them from an existing file.  (You should only choose this o' +
        'ption if none of  the node positions have changed since the last' +
        ' time the node positions were saved.)'
      Enabled = False
      TabOrder = 2
      AlignmentBtn = taLeftJustify
      LikePushButton = False
      VerticalAlignment = vaTop
      WordWrap = True
    end
    object rbCompute: TRadioButton95
      Left = 8
      Top = 144
      Width = 321
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Compute polyhedrons each time they are needed'
      Checked = True
      TabOrder = 3
      TabStop = True
      AlignmentBtn = taLeftJustify
      LikePushButton = False
      VerticalAlignment = vaTop
      WordWrap = True
    end
  end
  object BitBtn1: TBitBtn
    Left = 270
    Top = 176
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkClose
  end
end
