inherited PhotoEditor: TPhotoEditor
  AutoSize = True
  Caption = 'PhotoEditor'
  ClientHeight = 420
  ClientWidth = 465
  ExplicitWidth = 471
  ExplicitHeight = 448
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxLayoutControl1: TdxLayoutControl
    Width = 465
    Height = 420
    ExplicitWidth = 465
    ExplicitHeight = 420
    inherited btnOk: TcxButton
      Left = 299
      Top = 385
      ExplicitLeft = 299
      ExplicitTop = 385
    end
    inherited btnCancel: TcxButton
      Left = 380
      Top = 385
      ExplicitLeft = 380
      ExplicitTop = 385
    end
    inherited teCaption: TcxTextEdit
      Properties.ReadOnly = True
      ExplicitWidth = 399
      Width = 399
    end
    object imPreview: TcxImage [4]
      Left = 56
      Top = 64
      Properties.FitMode = ifmProportionalStretch
      Properties.GraphicClassName = 'TdxSmartImage'
      Properties.PopupMenuLayout.MenuItems = [pmiLoad, pmiWebCam]
      Properties.ReadOnly = False
      Properties.ShowFocusRect = False
      Properties.OnEditValueChanged = imPreviewPropertiesEditValueChanged
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Transparent = True
      Height = 313
      Width = 399
    end
    inherited dxLayoutControl1Group_Root: TdxLayoutGroup
      ItemIndex = 3
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'Image'
      Control = imPreview
      ControlOptions.OriginalHeight = 313
      ControlOptions.OriginalWidth = 385
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 240
    Top = 160
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
