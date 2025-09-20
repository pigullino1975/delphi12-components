object dxMessageDialogForm: TdxMessageDialogForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'dxMessageDialogForm'
  ClientHeight = 44
  ClientWidth = 200
  Color = clBtnFace
  KeyPreview = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 200
    Height = 44
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = LayoutCxLookAndFeel
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lcIcon: TdxLayoutImageItem
      Parent = lcContentHost
      AlignHorz = ahLeft
      AlignVert = avTop
      Index = 0
    end
    object lcMessage: TdxLayoutLabeledItem
      Parent = lcMessageHost
      AlignVert = avClient
      CaptionOptions.WordWrap = True
      Index = 0
    end
    object lcButtonHost: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'New Group'
      Offsets.Top = 8
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lcContentHost: TdxLayoutGroup
      Parent = lcMainGroup_Root
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object lcMessageHost: TdxLayoutGroup
      Parent = lcContentHost
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      ScrollOptions.Vertical = smIndependent
      ShowBorder = False
      Index = 1
    end
  end
  object LayoutLookAndFeelList: TdxLayoutLookAndFeelList
    Left = 300
    Top = 8
    object LayoutCxLookAndFeel: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
