object Form1: TForm1
  Left = 330
  Top = 202
  BorderStyle = bsSingle
  Caption = 'QImport3 Demo -- Import to the user defined destination'
  ClientHeight = 416
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Import !'
    TabOrder = 0
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 40
    Width = 412
    Height = 367
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 19
    TabOrder = 1
  end
  object Button2: TButton
    Left = 345
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Clear Grid'
    TabOrder = 2
    OnClick = Button2Click
  end
  object QImportXLS1: TQImport3XLS
    ImportDestination = qidUserDefined
    Map.Strings = (
      '1=A1-A18'
      '2=B1-B18'
      '3333=C1-C18'
      '444444=D1-D18'
      'ooooo=E1-E18')
    Formats.BooleanTrue.Strings = (
      'True')
    Formats.BooleanFalse.Strings = (
      'False')
    Formats.NullValues.Strings = (
      'Null')
    FieldFormats = <>
    ErrorLogFileName = 'error.log'
    AddType = qatInsert
    OnBeforeImport = QImportXLS1BeforeImport
    OnAfterImport = QImportXLS1AfterImport
    OnUserDefinedImport = QImportXLS1UserDefinedImport
    FileName = 'country.xls'
    Left = 96
    Top = 8
  end
end
