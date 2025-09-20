object fmImpDlg: TfmImpDlg
  Left = 262
  Top = 248
  Width = 553
  Height = 354
  Caption = 'TQimport3Wizard Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 545
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
      Width = 233
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
  object DBGrid: TDBGrid
    Left = 0
    Top = 31
    Width = 545
    Height = 289
    Align = alClient
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Qimport3Wizard1: TQImport3Wizard
    DataSet = pFIBDataSet1
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
    OnAfterImport = Qimport3Wizard1AfterImport
    OnBeforePost = Qimport3Wizard1BeforePost
    Left = 63
    Top = 92
  end
  object DataSource1: TDataSource
    DataSet = pFIBDataSet1
    Left = 76
    Top = 120
  end
  object pFIBDatabase1: TpFIBDatabase
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'user_name=SYSDBA'
      'password=masterkey')
    DefaultTransaction = pFIBTransaction1
    SQLDialect = 1
    Timeout = 0
    WaitForRestoreConnect = 0
    Left = 48
    Top = 120
  end
  object pFIBTransaction1: TpFIBTransaction
    DefaultDatabase = pFIBDatabase1
    TimeoutAction = TARollback
    Left = 48
    Top = 148
  end
  object pFIBDataSet1: TpFIBDataSet
    InsertSQL.Strings = (
      'insert into country (name, capital, continent, area, population)'
      '  values(:name, :capital, :continent, :area, :population)')
    SelectSQL.Strings = (
      'select * from country')
    Transaction = pFIBTransaction1
    Database = pFIBDatabase1
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    Left = 76
    Top = 148
    poUseBooleanField = False
  end
  object pFIBQuery1: TpFIBQuery
    Transaction = pFIBTransaction1
    Database = pFIBDatabase1
    SQL.Strings = (
      'delete from country')
    Left = 104
    Top = 147
  end
end
