inherited AlbumEditor: TAlbumEditor
  Caption = 'AlbumEditor'
  ClientHeight = 260
  ClientWidth = 454
  ExplicitWidth = 460
  ExplicitHeight = 288
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxLayoutControl1: TdxLayoutControl
    Width = 454
    Height = 260
    ExplicitWidth = 454
    ExplicitHeight = 260
    inherited btnOk: TcxButton
      Left = 288
      Top = 225
      ExplicitLeft = 288
      ExplicitTop = 225
    end
    inherited btnCancel: TcxButton
      Left = 369
      Top = 225
      ExplicitLeft = 369
      ExplicitTop = 225
    end
    inherited teCaption: TcxTextEdit
      Left = 64
      ExplicitLeft = 64
      ExplicitWidth = 380
      Width = 380
    end
    inherited deDate: TcxDateEdit
      Left = 64
      ExplicitLeft = 64
    end
    object mComment: TcxMemo [4]
      Left = 64
      Top = 64
      Style.HotTrack = False
      TabOrder = 4
      Height = 147
      Width = 380
    end
    inherited dxLayoutControl1Group_Root: TdxLayoutGroup
      ItemIndex = 3
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'Comment:'
      Control = mComment
      ControlOptions.OriginalHeight = 147
      ControlOptions.OriginalWidth = 370
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 24
    Top = 48
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
