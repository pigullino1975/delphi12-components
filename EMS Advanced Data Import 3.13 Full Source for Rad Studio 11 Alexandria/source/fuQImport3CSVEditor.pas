unit fuQImport3CSVEditor;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    {$IFDEF QI_UNICODE}
      System.WideStrings,
    {$ENDIF}
    System.SysUtils,
    Vcl.Graphics,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    Vcl.Controls,
    Vcl.ExtCtrls,
    System.Classes,
    Data.Db,
    Vcl.Grids,
    Vcl.ComCtrls,
    Winapi.Windows,
    Vcl.Buttons,
    Vcl.ImgList,
    Vcl.ToolWin,
  {$ELSE}
    {$IFDEF QI_UNICODE}
      {$IFDEF VCL10}
        WideStrings,
      {$ELSE}
        QImport3WideStrings,
      {$ENDIF}
    {$ENDIF}
    SysUtils,
    Graphics,
    Forms,
    Dialogs,
    StdCtrls,
    Controls,
    ExtCtrls,
    Classes,
    Db,
    Grids,
    ComCtrls,
    Windows,
    Buttons,
    ImgList,
    ToolWin,
  {$ENDIF}
  QImport3Common,
  QImport3StrTypes,
  QImport3ASCII,
  fuQImport3GridEditor,
  QImport3Encoding,
  QImport3StrIDs,
  QImport3CSVClasses;

type
  TfmQImport3CSVEditor = class(TfmQImport3GridEditor)
    laCSVEncoding: TLabel;
    cmbCSVEncoding: TComboBox;
    procedure cmbCSVEncodingChange(Sender: TObject);
  private
    FComma: AnsiChar;
    FQuote: AnsiChar;
    function GetCSVEncoding: TQICharsetType;
    procedure SetCSVEncoding(const Value: TQICharsetType);
  protected
    procedure FillGrid; override;
    procedure InitObjs; override;
    function MarkFirstRow: Boolean; override;
    procedure SetFileName(const Value: string); override;
  public
    property Comma: AnsiChar read FComma write FComma;
    property Quote: AnsiChar read FQuote write FQuote;
    property CSVEncoding: TQICharsetType read GetCSVEncoding write SetCSVEncoding;
  end;

function RunQImportCSVEditor(AImport: TQImport3ASCII): boolean;

implementation

{$R *.DFM}

function RunQImportCSVEditor(AImport: TQImport3ASCII): boolean;
var
  I: TQICharsetType;
begin
  with TfmQImport3CSVEditor.Create(Application) do
  try
    Import := AImport;
    Comma := AImport.Comma;
    FQuote := AImport.Quote;
    for I := Low(TQICharsetType) to High(TQICharsetType) do
      cmbCSVEncoding.Items.Add(QICharsetTypeNames[I]);
    FileName := AImport.FileName;
    SkipLines := AImport.SkipFirstRows;
    Result := ShowModal = mrOk;
    if Result then
      ApplyChanges;
  finally
    Free;
  end;
end;

procedure TfmQImport3CSVEditor.cmbCSVEncodingChange(Sender: TObject);
begin
  CSVEncoding := TQICharsetType(cmbCSVEncoding.ItemIndex);
  FillGrid;
end;

procedure TfmQImport3CSVEditor.FillGrid;
var
  CSVReader: TCSVFileReader;
  Value: qiString;
  n, i: integer;
  List: TList;
begin
  for i := 0 to FGrid.RowCount - 1 do
    for n := 0 to FGrid.ColCount - 1 do
      FGrid.Cells[n, i] := '';

  cmbCSVEncoding.ItemIndex := Integer(CSVEncoding);    

  if not FileExists(FileName) then Exit;

  CSVReader := TCSVFileReader.Create;
  try
    CSVReader.SetFile(FileName);
    CSVReader.ColumnSeparatorCharCode := Ord(FComma);
    CSVReader.QuoteCharCode := Ord(FQuote);
    CSVReader.IgnoreEmptyLines := True;
    CSVReader.Charset := CSVEncoding;
    CSVReader.IgnoreSpecialCharacters := True;
    CSVReader.Open;
    try
      List := TList.Create;
      try
        n := 0;
        while not CSVReader.Eof and (n < 20) do
        begin
          for i := 0 to CSVReader.ColumnCount - 1 do
          begin
            Value := CSVReader.Columns[i].Value;
            if List.Count < i + 1 then
              List.Add(Pointer(Length(QImportLoadStr(QIW_CSV_GridCol))));
            if Integer(List[i]) < Length(Value) then
              List[i] := Pointer(Length(Value));
            if FGrid.ColCount < List.Count then
              FGrid.ColCount := List.Count;
            if FGrid.RowCount < n + 2 then
              FGrid.RowCount := n + 2;
            FGrid.Cells[i, n + 1] := Value;
          end;
          Inc(n);
          CSVReader.Next;
        end;
        FGrid.ColCount := List.Count;
        if List.Count > 0 then
          FGrid.FixedRows := 1;
        cbColumn.Items.Clear;
        cbColumn.Items.Add(EmptyStr);
        for i := 0 to List.Count - 1 do
        begin
          FGrid.ColWidths[i] := FGrid.Canvas.
          {$IFDEF QI_UNICODE}
            TextWidthW
          {$ELSE}
            TextWidth
          {$ENDIF}
          ('X') * (Integer(List[i]) + 1);
          FGrid.Cells[i, 0] := Format(QImportLoadStr(QIW_CSV_GridCol), [i + 1]);
          cbColumn.Items.Add(IntToStr(i + 1));
        end;
        FGrid.RowHeights[0] := 18;
      finally
        List.Free;
      end;
    finally
      CSVReader.Close;
    end;
  finally
    CSVReader.Free;
  end;

  FNeedLoadFile := false;
end;

function TfmQImport3CSVEditor.GetCSVEncoding: TQICharsetType;
begin
  Result := TQImport3ASCII(Import).Encoding;
end;

procedure TfmQImport3CSVEditor.InitObjs;
begin
  inherited;
  FGrid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goColSizing];
  FGrid.RowCount := 0;
  odFileName.Filter := QImportLoadStr(QIF_CSV);
end;

function TfmQImport3CSVEditor.MarkFirstRow: Boolean;
begin
  Result := True;
end;

procedure TfmQImport3CSVEditor.SetCSVEncoding(const Value: TQICharsetType);
begin
  if TQImport3ASCII(Import).Encoding <> Value then
    TQImport3ASCII(Import).Encoding := Value;
end;

procedure TfmQImport3CSVEditor.SetFileName(const Value: string);
begin
  if (Length(FileName) > 0) and (FileName <> Value) then
    CSVEncoding := ctWinDefined;
  inherited;
end;

end.
