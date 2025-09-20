object fmImpDlg: TfmImpDlg
  Left = 285
  Top = 189
  Width = 552
  Height = 354
  Caption = 'TQimport3Wizard Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 544
    Height = 31
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    object btImport: TButton
      Left = 6
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Import data...'
      TabOrder = 0
      OnClick = btImportClick
    end
    object chbUseBeforePost: TCheckBox
      Left = 96
      Top = 8
      Width = 257
      Height = 17
      Caption = 'Use before post event'
      TabOrder = 1
    end
    object Button1: TButton
      Left = 462
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Empty table'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object pcDestinations: TPageControl
    Left = 0
    Top = 31
    Width = 544
    Height = 289
    ActivePage = tshDataSet
    Align = alClient
    TabOrder = 1
    OnChange = pcDestinationsChange
    object tshDataSet: TTabSheet
      Caption = 'Dataset'
      object dgrDataSet: TDBGrid
        Left = 0
        Top = 0
        Width = 536
        Height = 261
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
    object tshDBGrid: TTabSheet
      Caption = 'DBGrid'
      object DBGrid: TDBGrid
        Left = 0
        Top = 0
        Width = 536
        Height = 261
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'Name'
            Title.Alignment = taCenter
            Title.Caption = 'Country Name'
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Continent'
            Title.Alignment = taCenter
            Title.Caption = 'Country Continent'
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Population'
            Title.Alignment = taCenter
            Title.Caption = 'Country Population'
            Width = 110
            Visible = True
          end>
      end
    end
    object tshListView: TTabSheet
      Caption = 'ListView'
      object ListView: TListView
        Left = 0
        Top = 0
        Width = 536
        Height = 261
        Align = alClient
        Columns = <
          item
            Caption = 'NAME'
            Width = 110
          end
          item
            Caption = 'CAPITAL'
            Width = 110
          end
          item
            Caption = 'CONTINENT'
            Width = 110
          end
          item
            Caption = 'AREA'
            Width = 90
          end
          item
            Caption = 'POPULATION'
            Width = 90
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tshStringGrid: TTabSheet
      Caption = 'StringGrid'
      object StringGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 536
        Height = 261
        Align = alClient
        DefaultColWidth = 100
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        TabOrder = 0
      end
    end
  end
  object QImportWizard1: TQImport3Wizard
    DataSet = Table1
    DBGrid = DBGrid
    ListView = ListView
    StringGrid = StringGrid
    Formats.BooleanTrue.Strings = (
      'True')
    Formats.BooleanFalse.Strings = (
      'False')
    Formats.NullValues.Strings = (
      'Null')
    FieldFormats = <>
    ErrorLogFileName = 'error.log'
    ShowSaveLoadButtons = True
    AddType = qatInsert
    GridCaptionRow = 0
    GridStartRow = 1
    OnAfterImport = QImportWizard1AfterImport
    OnBeforePost = QImportWizard1BeforePost
    Left = 104
    Top = 120
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 76
    Top = 120
  end
  object Table1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 152
  end
end
