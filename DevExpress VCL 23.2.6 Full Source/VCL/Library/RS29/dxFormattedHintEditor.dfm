inherited frmFormattedHintEditor: TfrmFormattedHintEditor
  BorderIcons = [biSystemMenu, biMaximize]
  ClientHeight = 361
  ClientWidth = 584
  Constraints.MinHeight = 400
  Constraints.MinWidth = 550
  TextHeight = 13
  inherited dxLayoutControl1: TdxLayoutControl
    Width = 584
    Height = 361
    AutoSize = False
    inherited reBBCode: TcxRichEdit
      Height = 83
      Width = 536
    end
    inherited btnApply: TcxButton
      Left = 499
      Top = 326
      TabOrder = 16
    end
    inherited btnCancel: TcxButton
      Left = 418
      Top = 326
      TabOrder = 15
    end
    inherited btnOk: TcxButton
      Left = 337
      Top = 326
      TabOrder = 14
    end
    inherited reRtf: TcxRichEdit
      Height = 119
      Width = 536
    end
    object flHintPreview: TdxFormattedLabel [16]
      Left = 260
      Top = 210
      Caption = 'flHintPreview'
      ParentShowHint = False
      ShowHint = True
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Horz = taLeftJustify
    end
    object flAddHintStyleController: TdxFormattedLabel [17]
      Left = 10
      Top = 332
      Caption = 
        'We can'#39't find HintStyleController. Do you want [url]to add one[/' +
        'url]?'
      ParentShowHint = False
      ShowHint = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Horz = taCenter
      Properties.OnHyperlinkClick = flAddHintStyleControllerPropertiesHyperlinkClick
      AnchorX = 162
    end
    inherited lgMain: TdxLayoutGroup
      ItemIndex = 1
      UseIndent = False
    end
    inherited lgMarkupEditor: TdxLayoutGroup
      AlignVert = avClient
      SizeOptions.AssignedValues = [sovSizableVert]
      SizeOptions.SizableVert = True
    end
    inherited dxLayoutItem3: TdxLayoutItem
      SizeOptions.AssignedValues = [sovSizableVert]
      ControlOptions.OriginalHeight = 240
    end
    inherited lgTabGroup: TdxLayoutGroup
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = True
      SizeOptions.SizableVert = True
      SizeOptions.Height = 140
    end
    inherited lgRTFEditor: TdxLayoutGroup
      AlignVert = avClient
      SizeOptions.AssignedValues = [sovSizableVert]
    end
    inherited lgEditor: TdxLayoutGroup
      SizeOptions.AssignedValues = [sovSizableVert]
      SizeOptions.SizableVert = True
      Hidden = False
      UseIndent = False
    end
    inherited dxLayoutItem1: TdxLayoutItem
      Visible = False
    end
    inherited dxLayoutItem6: TdxLayoutItem
      SizeOptions.AssignedValues = [sovSizableVert]
    end
    object dxliTextPreview: TdxLayoutItem
      Parent = lgPreview
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = flHintPreview
      ControlOptions.AlignHorz = ahCenter
      ControlOptions.MinHeight = 30
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 63
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgPreview: TdxLayoutGroup
      Parent = lgMain
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Hint Preview'
      Offsets.Bottom = 20
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = True
      SizeOptions.SizableVert = True
      SizeOptions.Height = 110
      Padding.Bottom = 20
      Padding.Left = 20
      Padding.Right = 20
      Padding.Top = 20
      Padding.AssignedValues = [lpavBottom, lpavLeft, lpavRight, lpavTop]
      ScrollOptions.Horizontal = smAuto
      ScrollOptions.Vertical = smAuto
      Index = 2
    end
    object dxLayoutSplitterItem1: TdxLayoutSplitterItem
      Parent = lgMain
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      SizeOptions.Height = 3
      Index = 1
    end
    object liAddHintStyleController: TdxLayoutItem
      Parent = lgBottomPanel
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = flAddHintStyleController
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 303
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
  inherited cxImageList1: TcxImageList
    FormatVersion = 1
  end
  inherited ActionList1: TActionList
    Left = 396
    Top = 94
  end
  inherited cdColor: TdxColorDialog
    Left = 468
    Top = 94
  end
  inherited FontDialog1: TFontDialog
    Left = 528
    Top = 94
  end
  inherited PopupMenu1: TPopupMenu
    Left = 252
    Top = 92
  end
end
