unit QImport3HTML;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF HTML}

uses
  {$IFDEF VCL16}
    System.Classes,
    System.IniFiles,
    Winapi.Windows,
    Winapi.ActiveX,
    System.Variants,
    System.SysUtils,
    System.Math,
    System.DateUtils,
    System.Win.ComObj,
  {$ELSE}
    Classes,
    IniFiles,
    ActiveX,
    Windows,
    {$IFDEF VCL6}
      Variants,
    {$ENDIF}
    SysUtils,
    Math,
    DateUtils,
    ComObj,
  {$ENDIF}
  QImport3,
  QImport3StrTypes,
  QImport3MSHtmlTLB,
  QImport3WideStrUtils,
  QImport3Common;

type
  THTMLCell = class(TCollectionItem)
  private
    FText: qiString;
  public
    property Text: qiString read FText write FText;
  end;

  THTMLCellList = class(TCollection)
  private
    function GetItem(Index: Integer): THTMLCell;
    procedure SetItem(Index: Integer; const Value: THTMLCell);
  public
    function Add: THTMLCell;
    property Items[Index: Integer]: THTMLCell read GetItem write SetItem; default;
  end;

  THTMLRow = class(TCollectionItem)
  private
    FCells: THTMLCellList;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Cells: THTMLCellList read FCells;
  end;

  THTMLRowList = class(TCollection)
  private
    function GetItem(Index: Integer): THTMLRow;
    procedure SetItem(Index: Integer; const Value: THTMLRow);
  public
    function Add: THTMLRow;
    property Items[Index: Integer]: THTMLRow read GetItem write SetItem; default;
  end;

  THTMLTable = class(TCollectionItem)
  private
    FRows: THTMLRowList;
    procedure SetRows(const Value: THTMLRowList);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Rows: THTMLRowList read FRows write SetRows;
  end;

  THTMLTableList = class(TCollection)
  private
    function GetItem(Index: Integer): THTMLTable;
    procedure SetItem(Index: Integer; const Value: THTMLTable);
  public
    function Add: THTMLTable;
    property Items[Index: Integer]: THTMLTable read GetItem write SetItem; default;
  end;

  THTMLFile = class
  private
    FFileName: string;
    FLoaded: Boolean;
    FTableList: THTMLTableList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load(const LoadingTimeOut: Word; const ARowCount: Integer = 0);
    procedure Clear;
    property FileName: string read FFileName write FFileName;
    property TableList: THTMLTableList read FTableList;
  end;

  TQImport3HTML = class(TQImport3)
  private
    FHTML: THTMLFile;
    FCounter: Integer;
    FTableNumber: Integer;
    FExternalHTMLFile: Boolean;
    FLoadingTimeOut: Word;
    procedure SetTableNumber(const Value: Integer);
  protected
    procedure DoBeforeImport; override;
    procedure StartImport; override;
    function CheckCondition: Boolean; override;
    function Skip: Boolean; override;
    procedure ChangeCondition; override;
    procedure FinishImport; override;
    procedure DoAfterImport; override;
    procedure FillImportRow; override;
    function ImportData: TQImportResult; override;
    procedure DoLoadConfiguration(IniFile: TIniFile); override;
    procedure DoSaveConfiguration(IniFile: TIniFile); override;
    property HTML: THTMLFile read FHTML write FHTML;
  public
    constructor Create(AOwner: TComponent); override;
    property LoadingTimeOut: Word read FLoadingTimeOut
      write FLoadingTimeOut default 0;
  published
    property FileName;
    property SkipFirstRows default 0;
    property TableNumber: Integer read FTableNumber
      write SetTableNumber default 0;
  end;

  //igorp - ����� ��� ���������� javascript ��� ��������
  TDocLoadController =  class(TInterfacedObject, IDispatch, IOLEClientSite)
  public
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    function SaveObject: HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker): HResult; stdcall;
    function GetContainer(out container: IOleContainer): HResult; stdcall;
    function ShowObject: HResult; stdcall;
    function OnShowWindow(fShow: BOOL): HResult; stdcall;
    function RequestNewObjectLayout: HResult; stdcall;
  end;

  TDefault = class(TObject);

function SafeUtf8DecodeEx(const Source: AnsiString; RaiseOnError: Boolean = False): WideString;

{$ENDIF}

implementation

{$IFDEF HTML}

const
  sFileNameNotDefined = 'File name is not defined';
  sFileNotFound = 'File %s not found';
  ErrorSymbol: AnsiChar = '?';
  DISPID_AMBIENT_DLCONTROL=-5512;

procedure HTMLFileLoadDispatchMsg;
const
  HTMLFileLoadMsg = $8002;
var
  IsExistsMsg: Boolean;
  Msg: tagMSG;
  IsUnicodeMsg: Boolean;
begin
  if PeekMessage(Msg, 0, HTMLFileLoadMsg, HTMLFileLoadMsg, PM_NOREMOVE) then
  begin
    IsUnicodeMsg := (Msg.hwnd <> 0) and IsWindowUnicode(Msg.hwnd);
    if IsUnicodeMsg then
      IsExistsMsg := PeekMessageW(Msg, 0, HTMLFileLoadMsg, HTMLFileLoadMsg, PM_REMOVE)
    else
      IsExistsMsg := PeekMessage(Msg, 0, HTMLFileLoadMsg, HTMLFileLoadMsg, PM_REMOVE);
    if IsExistsMsg then
    begin
      TranslateMessage(Msg);
      if IsUnicodeMsg then
        DispatchMessageW(Msg)
      else
        DispatchMessage(Msg);
    end;
  end;
end;

function WaitDocumentLoading(const HTMLDocument: IHTMLDocument2;
  const LoadingTimeOut: Word): Boolean;
const
  CompleteFlag = 'complete';
var
  EndTime: TDateTime;
begin
  EndTime := IncSecond(Now, LoadingTimeOut);
  while CompareText(HTMLDocument.readyState, CompleteFlag) <> 0 do
  begin
    if (LoadingTimeOut <> 0) and (Now >= EndTime) then
    begin
      Result := False;
      Exit;
    end;
    HTMLFileLoadDispatchMsg;
  end;
  Result := True;
end;

procedure ParseHTML(HTMLFile: THTMLFile; const HTMLFileName: WideString; const ARowCount: Integer;
  const LoadingTimeOut: Word);
var
  HTMLTable: IHTMLTable;
  HTMLRow: IHTMLTableRow;
  HTMLCell: IHTMLElement;
  HTMLElem: IHTMLElement;
  HTMLDocument: IHTMLDocument2;
  DocControl: IOleClientSite;
  OleObj: IOleObject;
  OleControl: IOleControl;
  RowCount, i, j, k: Integer;
  PersistFile: IPersistFile;
begin
  if Assigned(HTMLFile) then
  begin
    HTMLDocument := CreateComObject(CLASS_HTMLDocument) as IHTMLDocument2;
    HTMLDocument.designMode := 'on';
    DocControl := TDocLoadController.Create;
    OleObj := HTMLDocument as IOleObject;
    OleObj.SetClientSite(DocControl);
    OleControl := HTMLDocument as IOleControl;
    OleControl.OnAmbientPropertyChange(DISPID_AMBIENT_DLCONTROL);
    try
      if Succeeded(HTMLDocument.QueryInterface(IPersistFile, PersistFile)) then
      begin
        if Succeeded(PersistFile.Load(PWideChar(HTMLFileName), STGM_READ)) then
        begin
          if not WaitDocumentLoading(HTMLDocument, LoadingTimeOut) then
            Exit;
          for i := 0 to HTMLDocument.all.length - 1 do
          begin
            HTMLDocument.all.item(i, 0).QueryInterface(IHTMLElement, HTMLElem);
            if QIUpperCase(HTMLElem.tagName) = 'TABLE' then
            begin
              HTMLFile.TableList.Add;
              HTMLDocument.all.item(i, 0).QueryInterface(IHTMLTable, HTMLTable);
              RowCount := HTMLTable.rows.length - 1;
              if ARowCount > 0 then
                RowCount := Min(ARowCount, RowCount);
              for j := 0 to RowCount do
              begin
                HTMLTable.rows.item(j, 0).QueryInterface(IHTMLTableRow, HTMLRow);
                HTMLFile.TableList.Items[HTMLFile.TableList.Count - 1].Rows.Add;
                for k := 0 to HTMLRow.cells.length - 1 do
                begin
                  HTMLRow.cells.item(k, 0).QueryInterface(IHTMLElement, HTMLCell);
                  HTMLFile.TableList.Items[HTMLFile.TableList.Count - 1].Rows[j].Cells.Add;
                  HTMLFile.TableList.Items[HTMLFile.TableList.Count - 1].Rows[j].Cells[k].Text :=
                    HTMLCell.innerText;
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      PersistFile := nil;
      HTMLDocument := nil;
    end;
  end;
end;

function SafeUtf8DecodeEx(const Source: AnsiString; RaiseOnError: Boolean = False): WideString;
var
  I, J: Integer;
  wc, c, c2: Cardinal;

  procedure Error(Code: Cardinal; Length: Integer);
  begin
    if RaiseOnError then
      raise Exception.Create('0x'+IntToHex(Code, Length*2));
    Result[J] := WideChar(ErrorSymbol);
    Inc(I);
    Inc(J);
  end;

begin
  SetLength(Result, Length(Source));
  I := 1;
  J := 1;
  while I <= Length(Source) do
  begin
    wc := Ord(Source[I]);
    if wc >= $80 then
    begin
      if (wc < $C0) or (wc >= $F0) then
      begin;
        Error(wc,1);
        continue;
      end;
      if I+1 > Length(Source) then
        break;
      c := Ord(Source[I+1]);
      if (c and $C0) <> $80 then
      begin
        Error((wc shl 8) + c, 2);
        continue;
      end;
      if wc < $E0 then
      begin
        wc := ((wc and $1F) shl 6) + (c and $3F);
        Inc(I, 2);
      end
      else
      begin
        if I+2 > Length(Source) then
          break;
        c2 := Ord(Source[I+2]);
        if (c2 and $C0) <> $80 then
        begin
          Error((wc shl 16) + (c shl 8) + c2, 3);
          continue;
        end;
        wc := ((wc and $F) shl 12) + ((c and $3F) shl 6) + (c2 and $3F);
        Inc(I, 3);
      end;
    end
    else
      Inc(I);
    Result[J] := WideChar(wc);
    Inc(J);
  end;
  SetLength(Result, J - 1);
end;

{ THTMLCellList }

function THTMLCellList.Add: THTMLCell;
begin
  Result := THTMLCell(inherited Add)
end;

function THTMLCellList.GetItem(Index: Integer): THTMLCell;
begin
  Result := THTMLCell(inherited Items[Index]);
end;

procedure THTMLCellList.SetItem(Index: Integer; const Value: THTMLCell);
begin
  inherited Items[Index] := Value;
end;

{ THTMLRow }

constructor THTMLRow.Create(Collection: TCollection);
begin
  inherited;
  FCells := THTMLCellList.Create(THTMLCell);
end;

destructor THTMLRow.Destroy;
begin
  FCells.Free;
  inherited;
end;

{ THTMLRowList }

function THTMLRowList.Add: THTMLRow;
begin
  Result := THTMLRow(inherited Add)
end;

function THTMLRowList.GetItem(Index: Integer): THTMLRow;
begin
  Result := THTMLRow(inherited Items[Index]);
end;

procedure THTMLRowList.SetItem(Index: Integer; const Value: THTMLRow);
begin
  inherited Items[Index] := Value;
end;

{ THTMLTableList }

function THTMLTableList.Add: THTMLTable;
begin
  Result := THTMLTable(inherited Add)
end;

function THTMLTableList.GetItem(Index: Integer): THTMLTable;
begin
  Result := THTMLTable(inherited Items[Index]);
end;

procedure THTMLTableList.SetItem(Index: Integer; const Value: THTMLTable);
begin
  inherited Items[Index] := Value;
end;

{ THTMLTable }

constructor THTMLTable.Create(Collection: TCollection);
begin
  inherited;
  FRows := THTMLRowList.Create(THTMLRow);
end;

destructor THTMLTable.Destroy;
begin
  FRows.Free;
  inherited;
end;

procedure THTMLTable.SetRows(const Value: THTMLRowList);
begin
  FRows.Assign(Value);
end;

{ THTMLFile }

constructor THTMLFile.Create;
begin
  inherited;
  FLoaded := False;
  FTableList := THTMLTableList.Create(THTMLTable);
end;

destructor THTMLFile.Destroy;
begin
  FTableList.Free;
  inherited;
end;

procedure THTMLFile.Load(const LoadingTimeOut: Word; const ARowCount: Integer = 0);
begin
  if FFileName = EmptyStr then
    raise Exception.Create(sFileNameNotDefined);
  if not FileExists(FFileName) then
    raise Exception.CreateFmt(sFileNotFound, [FFileName]);
  
  ParseHTML(Self, FFileName, ARowCount, LoadingTimeOut);
  FLoaded := True;
end;

procedure THTMLFile.Clear;
begin
  TableList.Clear;
  FLoaded := False;
end;

{ TQImport3HTML }

constructor TQImport3HTML.Create(AOwner: TComponent);
begin
  inherited;
  SkipFirstRows := 0;
  FTableNumber := 0;
  FLoadingTimeOut := 0;
end;

procedure TQImport3HTML.SetTableNumber(const Value: integer);
begin
  FTableNumber := Value;
end;

procedure TQImport3HTML.DoBeforeImport;
begin
  FExternalHTMLFile := Assigned(FHTML);
  if not FExternalHTMLFile then
  begin
    FHTML := THTMLFile.Create;
    FHTML.FileName := FileName;
    FHTML.Load(FLoadingTimeOut);
  end;
  FTotalRecCount := 0;
  if Assigned(FHTML) and (FTableNumber > 0) then
    FTotalRecCount := FHTML.FTableList[Pred(FTableNumber)].Rows.Count - SkipFirstRows;
  inherited;
end;

procedure TQImport3HTML.StartImport;
begin
  FCounter := 0;
end;

function TQImport3HTML.CheckCondition: Boolean;
begin
  Result := FCounter < (FTotalRecCount + SkipFirstRows);
end;

function TQImport3HTML.Skip: Boolean;
begin
  Result := (SkipFirstRows > 0) and (FCounter < SkipFirstRows);
end;

procedure TQImport3HTML.ChangeCondition;
begin
  Inc(FCounter);
end;

procedure TQImport3HTML.FinishImport;
begin
  if not Canceled and not IsCSV then
  begin
    if CommitAfterDone then
      DoNeedCommit
    else if (CommitRecCount > 0) and ((ImportedRecs + ErrorRecs) mod CommitRecCount > 0) then
      DoNeedCommit;
  end;
end;

procedure TQImport3HTML.DoAfterImport;
begin
  if not FExternalHTMLFile and Assigned(FHTML) then
  begin
    FHTML.Free;
    FHTML := nil;
  end;
  inherited;
end;

procedure TQImport3HTML.FillImportRow;
var
  j, k: Integer;
  stValue: qiString;
  p: Pointer;
  mapValue: qiString;
begin
  FImportRow.ClearValues;
  RowIsEmpty := True;
  for j := 0 to FImportRow.Count - 1 do
  begin
    if FImportRow.MapNameIdxHash.TryGetValue(FImportRow[j].Name, p) then
    begin
      k := Integer(p);
      stValue := '';
{$IFDEF VCL7}
      mapValue := Map.ValueFromIndex[k];
{$ELSE}
      mapValue := Map.Values[FImportRow[j].Name];
{$ENDIF}
      if FHTML.TableList[Pred(FTableNumber)].Rows[FCounter].Cells.Count >= StrToInt(mapValue) then
        stValue := FHTML.TableList[Pred(FTableNumber)].Rows[FCounter].Cells[Pred(StrToInt(mapValue))].Text;
      if stValue <> '' then
        while ord(stValue[1]) = 1042 do
          stValue := Copy(stValue, 3, Length(stValue) - 2);
      if AutoTrimValue then
        stValue := Trim(stValue);
      RowIsEmpty := RowIsEmpty and (stValue = '');
      FImportRow.SetValue(Map.Names[k], stValue, IsBinary(FImportRow[j].ColumnIndex));
    end;
    DoUserDataFormat(FImportRow[j]);
  end;
end;

function TQImport3HTML.ImportData: TQImportResult;
begin
  Result := qirOk;
  try
    try
      if Canceled  and not CanContinue then
      begin
        Result := qirBreak;
        Exit;
      end;
      DataManipulation;
    except
      on E:Exception do
      begin
        try
          DestinationCancel;
        except
        end;
        DoImportError(E);
        Result := qirContinue;
        Exit;
      end;
    end;
  finally
    if (not IsCSV) and (CommitRecCount > 0) and not CommitAfterDone and
       (
        ((ImportedRecs + ErrorRecs) > 0)
        and ((ImportedRecs + ErrorRecs) mod CommitRecCount = 0)
       )
    then
      DoNeedCommit;
    if (ImportRecCount > 0) and
       ((ImportedRecs + ErrorRecs) mod ImportRecCount = 0) then
      Result := qirBreak;
  end;
end;

procedure TQImport3HTML.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    SkipFirstRows := ReadInteger(HTML_OPTIONS, HTML_SKIP_LINES, SkipFirstRows);
  end;
end;

procedure TQImport3HTML.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(HTML_OPTIONS, HTML_SKIP_LINES, SkipFirstRows);
  end;
end;

{TDocLoadController}

function TDocLoadController.GetTypeInfoCount(out Count: Integer): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TDocLoadController.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TDocLoadController.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TDocLoadController.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
const
 DLCTL_NO_SCRIPTS=$00000080;
begin
  Result:=S_OK;
  if DispID = DISPID_AMBIENT_DLCONTROL then
    PVariant(VarResult)^:=Integer(DLCTL_NO_SCRIPTS)
  else
    inherited;
end;

function TDocLoadController.SaveObject: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TDocLoadController.GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
 out mk: IMoniker): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TDocLoadController.OnShowWindow(fShow: BOOL): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TDocLoadController.RequestNewObjectLayout: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TDocLoadController.ShowObject: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TDocLoadController.GetContainer(out container: IOleContainer): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

{$ENDIF}

end.


