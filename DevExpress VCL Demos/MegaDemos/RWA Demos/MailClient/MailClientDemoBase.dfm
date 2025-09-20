object MailClientDemoBaseFrame: TMailClientDemoBaseFrame
  Left = 0
  Top = 0
  Width = 959
  Height = 626
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object bmFrame: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = DM.ilToolbarsSmall
    ImageOptions.LargeImages = DM.ilToolbarsLarge
    ImageOptions.StretchGlyphs = False
    PopupMenuLinks = <>
    Style = bmsUseLookAndFeel
    UseSystemFont = False
    Left = 784
    Top = 16
    PixelsPerInch = 96
  end
  object alFrame: TActionList
    Images = DM.ilToolbarsLarge
    Left = 840
    Top = 16
  end
  object ComponentPrinter: TdxComponentPrinter
    Version = 0
    OnBeforePreview = ComponentPrinterBeforePreview
    Left = 784
    Top = 64
    PixelsPerInch = 96
  end
end
