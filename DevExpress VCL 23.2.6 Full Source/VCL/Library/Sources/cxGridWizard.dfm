object cxGridWizardForm: TcxGridWizardForm
  Left = 194
  Top = 146
  BorderIcons = [biSystemMenu]
  Caption = 'Grid Wizard'
  ClientHeight = 581
  ClientWidth = 784
  Color = clBtnFace
  Constraints.MinHeight = 620
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object wcMain: TdxWizardControl
    Left = 0
    Top = 0
    Width = 784
    Height = 581
    Buttons.CustomButtons.Buttons = <>
    Buttons.Finish.AlwaysVisible = True
    Buttons.Help.Visible = False
    LookAndFeel.NativeStyle = True
    OptionsAnimate.ResizeAnimation = wcraEnabled
    OptionsAnimate.TransitionEffect = wcteNone
    OnButtonClick = wcMainButtonClick
    OnPageChanged = wcMainPageChanged
    OnPageChanging = wcMainPageChanging
    object wcpWelcome: TdxWizardControlPage
      Header.Title = 'Welcome'
    end
    object wcpStart: TdxWizardControlPage
      Header.Title = 'Start'
    end
    object wcpFinish: TdxWizardControlPage
      Header.Title = 'Finish'
      object grPreviewGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 762
        Height = 445
        Align = alClient
        TabOrder = 0
        object grPreviewGridLevel: TcxGridLevel
        end
      end
    end
  end
end
