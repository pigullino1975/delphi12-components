unit QImport3XML;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    System.SysUtils,
    System.Math,
    Winapi.Windows,
    System.Classes,
    System.IniFiles,
    Data.DB,
    System.DateUtils,
  {$ELSE}
    SysUtils,
    Math,
    Windows,
    Classes,
    DB,
    IniFiles,
    {$IFDEF VCL6}
     DateUtils,
    {$ENDIF}
    {$IFNDEF VCL12}
     QImport3StringBuilder,
    {$ENDIF}
  {$ENDIF}
  QImport3,
  QImport3WideStrUtils,
  QImport3StrTypes,
  QImport3Encoding,
  QImport3Common;

const
  EndL = #13#10;
  sSchemaNotFound = 'Schema file %s not found!';

type
  TQIXMLDocType = (xtDataPacket2, xtAccess, xtUndefined);

  TXMLTagList = class;

  TXMLTag = class(TCollectionItem)
  private
    FParent: TXMLTag;
    FTagList: TXMLTagList;
    FName: qiString;
    FAttributes: TqiStrings;
    FAttrNames: TqiStrings;
    FChildren: TXMLTagList;
    procedure SetAttributes(Value: TqiStrings);
    procedure SetChildren(Value: TXMLTagList);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Parent: TXMLTag read FParent;
    property TagList: TXMLTagList read FTagList;
    property Name: qiString read FName write FName;
    property Attributes: TqiStrings read FAttributes write SetAttributes;
    property Children: TXMLTagList read FChildren write SetChildren;
  end;

  TXMLTagList = class(TCollection)
  private
    FParent: TxmlTag;
    function GetItem(Index: integer): TXMLTag;
    procedure SetItem(Index: integer; Value: TXMLTag);
  public
    constructor Create(Parent: TxmlTag);
    function Add: TXMLTag;
    property Parent: TxmlTag read FParent;
    property Items[Index: integer]: TXMLTag read GetItem write SetItem; default;
  end;

  TXMLFile = class
  private
    FEncoding: TQICharsetType;
    FData: qiString;
    FFileName: qiString;
    FHeader: TXMLTag;
    FTags: TXMLTagList;
    FLoaded: boolean;
    FEof: boolean;
    FPosition: integer;
    FFileType: TQIXMLDocType;
    FParsingFailed: Boolean;
    procedure SetHeader(Value: TXMLTag);
    procedure SetTags(Value: TXMLTagList);
    function GetFields: TXMLTagList;
    function GetFieldCount: integer;
    function GetRows: TXMLTagList;
    function GetRowCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    function GetNextTag: TxmlTag;
    procedure Load(FieldsOnly: boolean);
    procedure Clear;
    function IsCurrentFile: Boolean;
    function ForceLoad(AFieldsOnly: Boolean): Boolean;
    procedure LoadEncodingFromDeclaration;
    property FileName: qiString read FFileName write FFileName;
    property Header: TXMLTag read FHeader write SetHeader;
    property Tags: TXMLTagList read FTags write SetTags;
    property Fields: TXMLTagList read GetFields;
    property FieldCount: integer read GetFieldCount;
    property Rows: TXMLTagList read GetRows;
    property RowCount: integer read GetRowCount;
    property Eof: boolean read FEof;
    property Encoding: TQICharsetType read FEncoding write FEncoding default ctUtf8;
    property FileType: TQIXMLDocType read FFileType write FFileType;
  end;

  TQImport3XML = class(TQImport3)
  private
    FXML: TXMLFile;
    FCounter: integer;
    FXMLTag: TXMLTag;
    FEncoding: TQICharsetType;
    FDocumentType: TQIXMLDocType;
  protected
    function GetDateTimeValue(const AValue: qiString): Variant; override;
    procedure DoBeforeImport; override;
    procedure DoAfterImport; override;
    procedure StartImport; override;
    function CheckCondition: boolean; override;
    procedure ChangeCondition; override;
    procedure FinishImport; override;
    procedure FillImportRow; override;
    function Skip: boolean; override;
    function ImportData: TQImportResult; override;
    procedure DoLoadConfiguration(IniFile: TIniFile); override;
    procedure DoSaveConfiguration(IniFile: TIniFile); override;
    function GetStringValue(const AValue: qiString; const AFieldType: TFieldType): Variant; override;
    function GetBytesValue(const AValue: qiString): Variant; override;
    function CheckBinaryData(const AValue: qiString): qiString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FileName;
    property SkipFirstRows default 0;
    property Encoding: TQICharsetType read FEncoding write FEncoding default ctUtf8;
    property DocumentType: TQIXMLDocType read FDocumentType write FDocumentType default xtDataPacket2;
    property XML: TXMLFile read FXML;
  end;

function ParseXML(XMLFile: TXMLFile; const XML: qiString; FieldsOnly,
  SingleTag: boolean; SilentParse: Boolean = False): TXMLTag;

function ParseAccessXMLFields(XMLFile: TXMLFile; const XML: qiString; FieldsOnly, SingleTag: Boolean): TXMLTag;
function ParseAccessXMLData(XMLFile: TXMLFile; const XML: qiString;
  RowsTag, FieldsTag: TXMLTag; const NoSchema: Boolean; FieldsOnly, SingleTag: Boolean): TXMLTag;

implementation

const
  sFileNameNotDefined = 'File name is not defined';
  sFileNotFound = 'File %s not found';
  sXMLHeaderFailed = 'XML header failed';
  sFileNotXML = 'File %s is not in XML format';
  sUnexpectedSymbol = 'Unexpected symbol %s at position %d';
  sVersionAttributeExpected = 'Version attribute expected but $s found';
  sInvalidXMLDeclaration = 'Invalid XML declaration';
  sAttributeDuplicates = 'Attribute %s duplicates';
  sUnexpectedAttributeName = 'Unexpected attriute name %s';
  sExpectingOneButOtherFound = 'Expecting %s but %s found';
  sUnexpectedTagName = 'Unexpected tag name %s';
  sCorrespondingTagNotFound = '%s - corresponding tag not found';

const
  sWhiteSpace = [#$20, #$9, #$D, #$A];
  sWhiteSpaceName = [#$9, #$D, #$A];
  sLetter     = [#$41..#$5A, #$61..#$7A, #$C0..#$D6, #$D8..#$F6, #$F8..#$FF];
  sNumber     = [#$30..#$39];
  sNameChar   = sLetter + sNumber + ['.', '-', '_', ':', #$B7];
  sNameStart  = sLetter + ['_', ':'];
  sQuote      = ['"', ''''];
  sSlash      = '/';

  sQuot       = '"'; sQuotEncode = '&quot;';
  sAmp        = '&'; sAmpEncode  = '&amp;';
  sLt         = '<'; sLtEncode   = '&lt;';
  sGt         = '>'; sGtEncode   = '&gt;';
  sSp         = ' '; sSpEncode   = '&#160;';

  sEqual      = '=';
  sQuestion   = '?';

  sDATAPACKET = 'DATAPACKET';
  sMETADATA   = 'METADATA';
  sFIELDS     = 'FIELDS';
  sFIELD      = 'FIELD';
  sROWDATA    = 'ROWDATA';
  sROW        = 'ROW';

  ENCODING_ATTR = 'encoding';
  STANDALONE_ATTR = 'standalone';

type
  TxmlState = (stWaitXMLDecl, stReadXMLDecl, stWaitTag, stReadTag, stBreak, stWaitAccessDataRoot);
  TxmlTagState = (tstUnknown, tstWaitXMLDecl, tstWaitTagName, tstReadTagName,
    tstWaitAttrName, tstReadAttrName, tstWaitEqual, tstWaitAttrValue, tstReadAttrValue);

function ParseXML(XMLFile: TXMLFile; const XML: qiString; FieldsOnly,
  SingleTag: boolean; SilentParse: Boolean = False): TxmlTag;

var
  st: TxmlState;
  FAttributes: TqiStrings;
  FTag: TXMLTag;
  FAttrName, FAttrValue: qiString;

  procedure CheckAttributeName(const AttrName: qiString);
  var
    i: integer;
  begin
    case st of
      stReadXMLDecl:
        if XMLFile.Header.Attributes.Count = 0 then
        begin
          if AttrName <> 'version' then
            if SilentParse then
            begin
              XMLFile.FParsingFailed := True;
              Exit;
            end
            else
              raise Exception.CreateFmt(sVersionAttributeExpected, [AttrName]);
        end
        else if (AttrName = STANDALONE_ATTR) or (AttrName = ENCODING_ATTR) then
        begin
          for i := 0 to XMLFile.Header.Attributes.Count - 1 do
            if XMLFile.Header.Attributes[i] = FAttrName then
              if SilentParse then
              begin
                XMLFile.FParsingFailed := True;
                Exit;
              end
              else
                raise Exception.CreateFmt(sAttributeDuplicates, [FAttrName]);
        end
        else if SilentParse then
        begin
          XMLFile.FParsingFailed := True;
          Exit;
        end
        else
          raise Exception.CreateFmt(sUnexpectedAttributeName, [AttrName]);
    end;
    FAttrName := AttrName;
  end;

  procedure ReadAttributes(const AttrStr: qiString);
  var
    i: integer;
    tst: TxmlTagState;
    ch, qu: qiChar;
    buf: qiString;
  begin
    tst := tstWaitAttrName;
    buf := EmptyStr;
    qu := #0;
    for i := 1 to Length(AttrStr) do
    begin
      ch := AttrStr[i];
      case tst of
        tstWaitAttrName:
          if QImport3Common.CharInSet(ch, sWhiteSpace) then
            tst := tstWaitAttrName
          else if QImport3Common.CharInSet(ch, sNameStart) then
          begin
            tst := tstReadAttrName;
            buf := EmptyStr;
          end
          else if SilentParse then
          begin
            XMLFile.FParsingFailed := True;
            Exit;
          end
          else
            raise Exception.CreateFmt(sUnexpectedSymbol, [ch, i]);

        tstReadAttrName:
          if QImport3Common.CharInSet(ch, sNameChar) then
            tst := tstReadAttrName
          else if QImport3Common.CharInSet(ch, sWhiteSpace) then
          begin
            CheckAttributeName(buf);
            tst := tstWaitEqual;
          end
          else if ch = sEqual then
          begin
            CheckAttributeName(buf);
            tst := tstWaitAttrValue;
          end
          else if SilentParse then
          begin
            XMLFile.FParsingFailed := True;
            Exit;
          end
          else
            raise Exception.CreateFmt(sUnexpectedSymbol, [ch, i]);

        tstWaitEqual:
          if QImport3Common.CharInSet(ch, sWhiteSpace) then
            tst := tstWaitEqual
          else if ch = sEqual then
            tst := tstWaitAttrValue
          else
          if SilentParse then
          begin
            XMLFile.FParsingFailed := True;
            Exit;
          end
          else
            raise Exception.CreateFmt(sUnexpectedSymbol, [ch, i]);

        tstWaitAttrValue:
          if QImport3Common.CharInSet(ch, sWhiteSpace) then
            tst := tstWaitAttrValue
          else if QImport3Common.CharInSet(ch, sQuote) then
          begin
            qu := ch;
            tst := tstReadAttrValue;
            buf := EmptyStr;
            Continue;
          end
          else if SilentParse then
          begin
            XMLFile.FParsingFailed := True;
            Exit;
          end
          else
            raise Exception.CreateFmt(sUnexpectedSymbol, [ch, i]);

        tstReadAttrValue:
          if QImport3Common.CharInSet(ch, sQuote) and (ch = qu) then
          begin
            FAttrValue := buf;
            if Assigned(FAttributes) then
            begin
              FAttributes.Values[FAttrName] := FAttrValue;
              tst := tstWaitAttrName;
              buf := EmptyStr;
              FAttrName := EmptyStr;
              FAttrValue := EmptyStr;
            end;
            qu := #0;
          end;
      end;
      buf := buf + ch;
    end;
  end;

  procedure FastReadAttributes(const AttrStr: qiString; ATag: TXMLTag);
  var
    TempStr, CurAttrName, CurAttrValue, BegValue, QStr: qiString;
  begin
    TempStr := AttrStr;
    BegValue := QIString('="');
    QStr := QIString('"');
    while Pos(BegValue, TempStr) > 0 do
    begin
      CurAttrName := Trim(Copy(TempStr, 1, Pos(BegValue, TempStr) - 1));
      TempStr := Trim(QIStringReplace(TempStr, CurAttrName + BegValue,'',[]));
      CurAttrValue := Copy(TempStr, 1, Pos(QStr, TempStr) - 1);
      TempStr := QIStringReplace(TempStr, CurAttrValue + QStr,'',[]);
      if Assigned(FAttributes) then
        FAttributes.Values[CurAttrName] := CurAttrValue;
      if Assigned(ATag.FAttrNames) then
        if (ATag.FAttrNames.IndexOf(CurAttrName) = -1) then
          ATag.FAttrNames.Add(CurAttrName);
    end;
  end;

  function ParseXMLTag(const Tag: qiString): TXMLTag;
  var
    i: integer;
    ch: qiChar;
    buf: qiString;
    tst: TxmlTagState;
    TagList: TXMLTagList;
  begin
    buf := EmptyStr;
    case st of
      stReadXMLDecl: begin
        buf := Copy(Tag, 1, 4);
        if (buf = '?xml') and (Tag[Length(Tag)] = '?') then
        begin
          FAttributes := XMLFile.Header.Attributes;
          buf := Copy(Tag, 5, Length(Tag) - 5);
          ReadAttributes(buf);
        end
        else
          raise Exception.Create(sXMLHeaderFailed)
      end;
      stReadTag: begin
        tst := tstWaitTagName;
        for i := 1 to Length(Tag) do
        begin
          ch := Tag[i];
          case tst of
            tstWaitTagName:
              if QImport3Common.CharInSet(ch, sNameStart + [sSlash]) then
                tst := tstReadTagName
              else if SilentParse then
              begin
                XMLFile.FParsingFailed := True;
                Exit;
              end
              else
                raise Exception.CreateFmt(sUnexpectedSymbol, [ch, i]);

            tstReadTagName:
              if QImport3Common.CharInSet(ch, sNameChar) then
                tst := tstReadTagName
              else if QImport3Common.CharInSet(ch,sWhiteSpace) then
                Break
              else if SilentParse then
              begin
                XMLFile.FParsingFailed := True;
                Exit;
              end
              else
                raise Exception.CreateFmt(sUnexpectedSymbol, [ch, i]);
          end;
          buf := buf + ch;
        end;

        if buf[1] = sSlash then
        begin
          if not SingleTag then
          begin
            if not (Assigned(FTag) and
               (Copy(buf, 2, Length(buf) - 1) = FTag.Name)) then
              raise Exception.CreateFmt(sCorrespondingTagNotFound, [buf]);
            FTag := FTag.Parent;
            if (UpperCase(buf) = sSlash + sFields) and FieldsOnly then
              st := stBreak;
          end
        end
        else begin
          if not SingleTag then
          begin
            if not Assigned(FTag)
              then TagList := XMLFile.Tags
              else TagList := FTag.Children;

            Result := TagList.Add;
          end
          else
            Result := TXMLTag.Create(nil);

          Result.Name := buf;
          FAttributes := Result.Attributes;
          if Tag[Length(Tag)] <> sSlash then
            FTag := Result;

          buf := Copy(Tag, Length(buf) + 1,
            Length(Tag) - Length(buf) - Integer(Tag[Length(Tag)] = sSlash));

          FastReadAttributes(buf, Result);
        end;
      end;
    end;
  end;

var
  ch: qiChar;
  buf: TStringBuilder;
begin
  Result := nil;
  XMLFile.FParsingFailed := False;
  if XMLFile.FPosition = 1
    then st := stWaitXMLDecl
    else st := stWaitTag;
  FAttributes := nil;
  FTag := nil;
  FAttrName := EmptyStr;
  FAttrValue := EmptyStr;

  buf := TStringBuilder.Create(128);
  try
    while XMLFile.FPosition < Length(XML) do
    begin
      if XMLFile.FParsingFailed then Exit;
      ch := XML[XMLFile.FPosition];

      if (XMLFile.FPosition = 1) and (Pos(qiString('<?'), XML) > 1) then
      begin
        ch := XML[Pos(qiString('<?'), XML)];
        XMLFile.FPosition := Pos(qiString('<?'), XML);
      end;

      case st of
        stWaitXMLDecl:
          if QImport3Common.CharInSet(ch, sWhiteSpace) then
            st := stWaitXMLDecl
          else if ch = sLt then
          begin
            st := stReadXMLDecl;
            FAttributes := XMLFile.Header.Attributes;
            buf.Length := 0;
            Inc(XMLFile.FPosition);
            Continue;
          end
          else if SilentParse then
          begin
            XMLFile.FParsingFailed := True;
            Exit;
          end
          else
            raise Exception.CreateFmt(sUnexpectedSymbol, [ch, XMLFile.FPosition]);

        stReadXMLDecl:
          if ch = sGt then
          begin
            Result := ParseXMLTag(buf.ToString);
            st := stWaitTag;
          end;

        stWaitTag:
          if QImport3Common.CharInSet(ch, sWhiteSpace) then
            st := stWaitTag
          else if ch = sLt then
          begin
            st := stReadTag;
            buf.Length := 0;
            Inc(XMLFile.FPosition);
            Continue;
          end
          else begin
            if SilentParse then
            begin
              XMLFile.FParsingFailed := True;
              Exit;
            end
            else
              raise Exception.CreateFmt(sUnexpectedSymbol, [ch, XMLFile.FPosition]);
          end;

        stReadTag:
          if ch = sGt then
          begin
            Result := ParseXMLTag(buf.ToString);
            if SingleTag then
            begin
              Inc(XMLFile.FPosition);
              Exit;
            end;
            st := stWaitTag;
          end;

        stBreak: Exit;
      end;

      buf.Append(ch);
      Inc(XMLFile.FPosition);
    end;
    XMLFile.FEof := true;
  finally
    buf.Free;
  end;
end;

{ TXMLTag }

constructor TXMLTag.Create(Collection: TCollection);
begin
  inherited;
  FTagList := nil;
  if Collection is TXMLTagList then
    FTagList := Collection as TXMLTagList;
  FParent := nil;
  if Assigned(FTagList) and Assigned(FTagList.Parent) then
    FParent := FTagList.Parent;
  FAttributes := TqiStringList.Create;
  FAttrNames := TqiStringList.Create;
  FChildren := TXMLTagList.Create(Self);
end;

destructor TXMLTag.Destroy;
begin
  FChildren.Free;
  FAttributes.Free;
  FAttrNames.Free;
  inherited;
end;

procedure TXMLTag.SetAttributes(Value: TqiStrings);
begin
  FAttributes.Assign(Value);
end;

procedure TXMLTag.SetChildren(Value: TXMLTagList);
begin
  FChildren.Assign(Value);
end;

{ TXMLTagList }

function TXMLTagList.Add: TXMLTag;
begin
  Result := TXMLTag(inherited Add)
end;

constructor TXMLTagList.Create(Parent: TxmlTag);
begin
  inherited Create(TXMLTag);
  FParent := Parent;
end;

function TXMLTagList.GetItem(Index: integer): TXMLTag;
begin
  Result := TXMLTag(inherited Items[Index]);
end;

procedure TXMLTagList.SetItem(Index: integer; Value: TXMLTag);
begin
  inherited Items[Index] := Value;
end;

{ TXMLFile }

constructor TXMLFile.Create;
begin
  inherited;
  FHeader := TXMLTag.Create(nil);
  FTags := TXMLTagList.Create(nil);
  FLoaded := false;
  FEof := true;
  FEncoding := ctUtf8;
  FFileType := xtDataPacket2;
end;

destructor TXMLFile.Destroy;
begin
  FTags.Free;
  FHeader.Free;
  inherited;
end;

procedure TXMLFile.Open;
var
  fileStream: TEncodedReadStream;
begin
  if FFileName = EmptyStr then
    raise Exception.Create(sFileNameNotDefined);
  if not FileExists(FFileName) then
    raise Exception.CreateFmt(sFileNotFound, [FFileName]);
  FData := EmptyStr;
  fileStream := TEncodedReadStream.Create(FFileName, FEncoding);
  try
    FData := fileStream.ReadToEnd;
  finally
    fileStream.Free;
  end;
  FPosition := 1;
  FEof := false;
end;

procedure TXMLFile.LoadEncodingFromDeclaration;
var
  fileStream: TEncodedReadStream;
  encPos, i, xmlDeclLen: Integer;
  encName: string;
  xmlDecl: qiString;
  encoding: TQICharsetType;
begin
  encName := EmptyStr;
  fileStream := TEncodedReadStream.Create(FFileName);
  try
    xmlDecl := fileStream.Readln;
    xmlDeclLen := Length(xmlDecl);
    encPos := QIPos(ENCODING_ATTR, xmlDecl);
    if (encPos > 0) then
    begin
      i := encPos + Length(ENCODING_ATTR);
      while (xmlDecl[i] <> '"') and (i <= xmlDeclLen) do Inc(i);
      Inc(i);
      while (xmlDecl[i] <> '"') and (i <= xmlDeclLen) do
      begin
        encName := encName + xmlDecl[i];
        Inc(i);
      end;
      if Length(encName) > 0 then
        for encoding := Low(QICharsetTypeNames) to High(QICharsetTypeNames) do
        begin
          if Pos(LowerCase(encName), LowerCase(QICharsetTypeNames[encoding])) > 0 then
          begin
            FEncoding := encoding;
            Exit;
          end;
        end;
    end;
  finally
    fileStream.Free;
  end;
  FEncoding := ctWinDefined;
end;

procedure TXMLFile.Close;
begin
  FEof := true;
end;

function TXMLFile.GetNextTag: TxmlTag;
begin
  if FileType = xtAccess then
    Result := ParseAccessXMLFields(Self, FData, false, true)
  else
    Result := ParseXML(Self, FData, false, true);
end;

procedure TXMLFile.Load(FieldsOnly: boolean);
begin
  Open;
  try
    if FileType = xtAccess then
      ParseAccessXMLFields(Self, FData, FieldsOnly, false)
    else
      ParseXML(Self, FData, FieldsOnly, false);
    FLoaded := true;
  finally
    Close;
  end;
end;

procedure TXMLFile.Clear;
begin
  Header.Name := EmptyStr;
  Header.Attributes.Clear;
  Header.Children.Clear;
  Tags.Clear;
  FLoaded := false;
end;

procedure TXMLFile.SetHeader(Value: TXMLTag);
begin
  FHeader.Assign(Value);
end;

procedure TXMLFile.SetTags(Value: TXMLTagList);
begin
  FTags.Assign(Value);
end;

function TXMLFile.GetFields: TXMLTagList;
var
  i, j, k: integer;
begin
  Result := nil;
  for i := 0 to Tags.Count - 1 do
    if CompareText(Tags[i].Name, sDATAPACKET) = 0 then
      for j := 0 to Tags[i].Children.Count - 1 do
        if CompareText(Tags[i].Children[j].Name, sMETADATA) = 0 then
          for k := 0 to Tags[i].Children[j].Children.Count - 1 do
            if CompareText(Tags[i].Children[j].Children[k].Name, sFIELDS) = 0 then
              Result := Tags[i].Children[j].Children[k].Children;
end;

function TXMLFile.GetFieldCount: integer;
var
  List: TXMLTagList;
begin
  Result := 0;
  if not FLoaded then Exit;
  List := GetFields;
  if Assigned(List) then
    Result := List.Count;
end;

function TXMLFile.GetRows: TXMLTagList;
var
  i, j: integer;
begin
  Result := nil;
  for i := 0 to Tags.Count - 1 do
    if CompareText(Tags[i].Name, sDATAPACKET) = 0 then
      for j := 0 to Tags[i].Children.Count - 1 do
        if CompareText(Tags[i].Children[j].Name, sROWDATA) = 0 then
          Result := Tags[i].Children[j].Children;
end;

function TXMLFile.IsCurrentFile: Boolean;
begin
  Result := ForceLoad(True);
end;

function TXMLFile.ForceLoad(AFieldsOnly: Boolean): Boolean;
begin
  Open;
  try
    FileType := xtDataPacket2;
    ParseXML(Self, FData, AFieldsOnly, false, True);
    FLoaded := not Self.FParsingFailed;
    if not FLoaded then
    try
      FileType := xtAccess;
      ParseAccessXMLFields(Self, FData, AFieldsOnly, false);
      FLoaded := not Self.FParsingFailed;
    except
      FileType := xtUndefined;
    end;
  finally
    if not FLoaded then
      FileType := xtUndefined;
    Result := FLoaded;
    Close;
  end;
end;

function TXMLFile.GetRowCount: integer;
var
  List: TXMLTagList;
begin
  Result := 0;
  if not FLoaded then Exit;
  List := GetRows;
  if Assigned(List) then
    Result := List.Count;
end;

{ TQImport3XML }

constructor TQImport3XML.Create(AOwner: TComponent);
begin
  inherited;
  SkipFirstRows := 0;
  FEncoding := ctUtf8;
  FDocumentType := xtDataPacket2; //xtAccess;
end;

procedure TQImport3XML.DoBeforeImport;
begin
  FXML := TXMLFile.Create;
  FXML.FileName := FileName;
  FXML.FileType := FDocumentType;
  FXML.Encoding := FEncoding;
  FXML.ForceLoad(False);
  FTotalRecCount := FXML.RowCount;
  inherited;
end;


procedure TQImport3XML.DoAfterImport;
begin
  if Assigned(FXML) then
  begin
    FXML.Free;
    FXML := nil;
  end;
  inherited;
end;

destructor TQImport3XML.Destroy;
begin
  if Assigned(FXMLTag) then
    FXMLTag.Free;
  inherited;
end;

procedure TQImport3XML.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    SkipFirstRows := ReadInteger(XML_OPTIONS, XML_SKIP_LINES, SkipFirstRows);
    Encoding := TQICharsetType(ReadInteger(XML_OPTIONS, XML_ENCODING, Integer(Encoding)));
  end;
end;

procedure TQImport3XML.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(XML_OPTIONS, XML_SKIP_LINES, SkipFirstRows);
    WriteInteger(XML_OPTIONS, XML_ENCODING, Integer(Encoding));
  end;
end;

procedure TQImport3XML.StartImport;
begin
  FCounter := 0;
end;

function TQImport3XML.CheckBinaryData(const AValue: qiString): qiString;
const
  sigBMP: AnsiString = #66#77;
var
  S: AnsiString;
  SigPos: Integer;
  LStream: TMemoryStream;
begin
  LStream := TMemoryStream.Create;
  try
    QIDecodeBase64(AValue, LStream);
    SetLength(S, LStream.Size);
    LStream.Position := 0;
    if Length(S) > 0 then
      LStream.Read(S[1], LStream.Size);
  finally
    FreeAndNil(LStream);
  end;
  if DocumentType = xtAccess then
  begin
    SigPos :=  Pos(sigBMP, S);
    if SigPos = 83 then //header of MS Access
    begin
      Delete(S, 1, SigPos - 1);
      Result := qiString(S);
    end
    else
      Result := qiString(S);
  end
  else
    Result := qiString(S);
end;


function TQImport3XML.CheckCondition: boolean;
begin
  Result := FCounter < FXML.RowCount;
end;

procedure TQImport3XML.ChangeCondition;
begin
  Inc(FCounter);
end;

procedure TQImport3XML.FinishImport;
begin
  if not Canceled and not IsCSV then
  begin
    if CommitAfterDone then
      DoNeedCommit
    else if (CommitRecCount > 0) and ((ImportedRecs + ErrorRecs) mod CommitRecCount > 0) then
      DoNeedCommit;
  end;
end;

function TQImport3XML.GetBytesValue(const AValue: qiString): Variant;
begin
  Result := inherited GetBytesValue(CheckBinaryData(AValue));
end;

function TQImport3XML.GetDateTimeValue(const AValue: qiString): Variant;
var
  S,N: qiString;
  Y,M,D,H,Mi,Se, I: Integer;
  Symbol: qiChar;
  TempD: TDateTime;

  function GetStrToInt(AStr: qiString; ADat: Integer): Integer;
  begin
    {$IFDEF VCL6}
      TryStrToInt(AStr, ADat);
      Result := ADat;
    {$ELSE}
      Result := StrToInt(AStr);
    {$ENDIF}
  end;

begin
  Y := 0;
  M := 0;
  D := 0;
  H := 0;
  Mi := 0;
  Se := 0;
  if (DocumentType = xtAccess) and (not TryStrToDateTime(AValue, TempD)) then
  begin
    //if date was not recognized as date, probably this is format of Access
    S := AValue;
    N := S;
    for I := 0 to 5 do
    begin
      case I of
       0,1: Symbol := '-';
         2: Symbol := 'T';
       else
         Symbol := ':'
      end;
      if I <> 5 then
        S := Copy(N,1, Pos(Symbol, N) - 1) else S := N;
      N := Copy(N, Length(S) + 2, Length(N));
      case I of
        0: Y := GetStrToInt(S, Y);
        1: M := GetStrToInt(S, M);
        2: D := GetStrToInt(S, D);
        3: H := GetStrToInt(S, H);
        4: Mi := GetStrToInt(S, Mi);
        5: Se := GetStrToInt(S, Se);
      end;
    end;
    {$IFDEF VCL6}
      Result := EncodeDateTime(Y,M,D,H,Mi,Se,0);
    {$ELSE}
      Result := EncodeDate(Y,M,D);
    {$ENDIF}
  end
  else
    Result := inherited GetDateTimeValue(AValue);
end;

function TQImport3XML.GetStringValue(const AValue: qiString; const AFieldType: TFieldType): Variant;
begin
  case AFieldType of
    ftBlob,ftOraClob,ftOraBlob:  Result := CheckBinaryData(AValue);
  else
    Result := inherited GetStringValue(AValue, AFieldType);
  end;
end;

procedure TQImport3XML.FillImportRow;
var
  j, k: integer;
  StrValue: qiString;
  mapValue: qiString;
  p: Pointer;

  function GetXMLField(AIndex: Integer): QIString;
  begin
    if AIndex < Map.Count then
      Result := Copy(Map[AIndex], Pos('=', Map[AIndex]) + 1, Length(Map[AIndex]))
    else
      Result := FImportRow[AIndex].Name;
  end;

begin
  FImportRow.ClearValues;

  if not Assigned(FXML.Rows) then Exit;

  RowIsEmpty := True;
  for j := 0 to FImportRow.Count - 1 do
  begin
    if FImportRow.MapNameIdxHash.TryGetValue(FImportRow[j].Name, p) then
    begin
      k := Integer(p);
{$IFDEF VCL7}
      mapValue := Map.ValueFromIndex[k];
{$ELSE}
      mapValue := Map.Values[FImportRow[j].Name];
{$ENDIF}
      StrValue := FXML.Rows[FCounter].Attributes.Values[Trim(mapValue)];
      StrValue := QIStringReplace(StrValue, sQuotEncode, sQuot, [rfReplaceAll, rfIgnoreCase]);
      StrValue := QIStringReplace(StrValue, sAmpEncode, sAmp, [rfReplaceAll, rfIgnoreCase]);
      StrValue := QIStringReplace(StrValue, sLtEncode, sLt, [rfReplaceAll, rfIgnoreCase]);
      StrValue := QIStringReplace(StrValue, sGtEncode, sGt, [rfReplaceAll, rfIgnoreCase]);
      StrValue := QIStringReplace(StrValue, sSpEncode, sSp, [rfReplaceAll, rfIgnoreCase]);

      if AutoTrimValue then
        StrValue := Trim(StrValue);
      RowIsEmpty := RowIsEmpty and (StrValue = '');
      FImportRow.SetValue(Map.Names[k], StrValue, IsBinary(FImportRow[j].ColumnIndex));
    end;
    DoUserDataFormat(FImportRow[j]);
  end;
end;

function TQImport3XML.Skip: boolean;
begin
  Result := (SkipFirstRows > 0) and (FCounter < SkipFirstRows);
end;

function TQImport3XML.ImportData: TQImportResult;
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


function ParseAccessXMLFields(XMLFile: TXMLFile; const XML: qiString; FieldsOnly, SingleTag: Boolean): TXMLTag;
var
  SchemaXML: TXMLFile;
  ch: qiChar;
  st: TxmlState;
  buf: QIString;
  DataTag, MetaTag, FieldsTag, RowsTag: TXMLTag;
  NoSpaces: QIString;
  SchemaName: qiString;
  NoSchema: Boolean;

  function FindSchemaFile: qiString;
  var
    PosName, PosFinish: Integer;
  begin
    Result := '';
    PosName := Pos(qiString('xsi:noNamespaceSchemaLocation="'), XML);
    if (PosName > 0) then
    begin
      PosFinish := Pos(qiString('"'), Copy(XML, PosName + 31, 100));
      Result := Copy(XML, PosName + 31, PosFinish - 1);
      Result := ExtractFilePath(XMLFile.FileName) + Result;
      if not FileExists(Result) then
        raise Exception.CreateFmt(sSchemaNotFound, [Result]);
   end else
      Exit;
  end;

  procedure PrepareTagStructure;
  begin
    XMLFile.Tags.Clear;
    DataTag := XMLFile.Tags.Add;
    DataTag.Name := sDataPacket;
    MetaTag := DataTag.Children.Add;
    MetaTag.Name := sMetaData;
    FieldsTag := MetaTag.Children.Add;
    FieldsTag.Name := sFields;
    RowsTag := DataTag.Children.Add;
    RowsTag.Name := sRowData;
  end;

  function ParseAccXMLTag(AStr: qiString; AXML: TXMLFile): TXMLTag;
  var
    TagName, TempStr: qiString;
    NamePos, TypePos: Integer;
  begin
    NamePos := Pos(qiString('xsd:element name="'), AStr);
    if (NamePos > 0) then
    begin
      TagName := StringReplace(AStr, 'xsd:element name="', '', []);
      TagName := Copy(TagName,1, Pos(qiString('"'), TagName) - 1);
      TempStr := LowerCase(Copy(AStr, NamePos, Length(AStr)));
      TypePos := Pos(qiString('od:sqlstype="'), TempStr);
      if (TypePos > 0) then
      begin
        TempStr := Copy(TempStr, TypePos + 13, Length(TempStr));
        TempStr := Copy(TempStr, 1, Pos(qiString('"'), TempStr) -1);
        Result := FieldsTag.Children.Add;
        Result.Name := sField;
        Result.Attributes.Add('FieldName=' + TagName);
        Result.Attributes.Add('DisplayLabel=' + TagName);
        Result.Attributes.Add('FieldType=' + TempStr);
        Result.Attributes.Add('FieldClass="TField"');
      end
      else
        Result := nil;
    end
    else
      Result := nil;
  end;

begin
  Result := nil;
  PrepareTagStructure;
  SchemaName := FindSchemaFile;
  NoSchema := Length(SchemaName) = 0;
  XMLFile.FParsingFailed := False;
  if not NoSchema then
  begin
    SchemaXML := TXMLFile.Create;
    SchemaXML.FileName := SchemaName;
    try
      SchemaXML.Open;
      NoSpaces := QIString(SchemaXML.FData);
      NoSpaces := StringReplace(Nospaces, #32, '', [rfReplaceAll]);

      buf := EmptyStr;
      st := stWaitTag;
      SchemaXML.FPosition := 1;

      while SchemaXML.FPosition < Length(SchemaXML.FData) do
      begin
        ch := qiChar(SchemaXML.FData[SchemaXML.FPosition]);
        case st of
          stWaitTag:
            if QImport3Common.CharInSet(ch, sWhiteSpace) then
              st := stWaitTag
            else if ch = sLt then
            begin
              st := stReadTag;
              buf := EmptyStr;
              Inc(SchemaXML.FPosition);
              Continue;
            end;

          stReadTag:
            if ch = sGt then
            begin
              Result := ParseAccXMLTag(buf, XMLFile);
              buf := EmptyStr;
              st := stWaitTag;
            end;

          stBreak: Exit;
        end;

        buf := buf + ch;
        Inc(SchemaXML.FPosition);
      end;
      SchemaXML.FEof := true;
    finally
      SchemaXML.Close;
      SchemaXML.Free;
    end;
  end;
  Result := ParseAccessXMLData(XMLFile, XMLFile.FData, RowsTag, FieldsTag, NoSchema, FieldsOnly, SingleTag);
end;

function ParseAccessXMLData(XMLFile: TXMLFile; const XML: qiString;
  RowsTag, FieldsTag: TXMLTag; const NoSchema: Boolean; FieldsOnly, SingleTag: Boolean): TXMLTag;
var
  ch: qiChar;
  st: TxmlState;
  buf, FirstFieldName, LastFieldName: qiString;
  FieldNames, databuf, attrnames: TqiStringList;
  FieldsAddedCount, FirstFieldPos: Integer; //counter of the fields' additions (if scheme not exists)

  procedure GetFieldNames(AStrings: TqiStrings);
  var
    I: Integer;
  begin
    if FieldsTag.Children.Count = 0 then
      Exit;
    AStrings.Clear;
    for I := 0 to FieldsTag.Children.Count - 1 do
      AStrings.Add(StringReplace(FieldsTag.Children.Items[I].Attributes[0], 'FieldName=', '', [rfReplaceAll]));
    LastFieldName := AStrings[FieldsTag.Children.Count - 1];
  end;

  function IsField(AName: qiString): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to FieldNames.Count - 1 do
      if CompareText(AName, FieldNames[I]) = 0 then
      begin
        Result := True;
        Break;
      end;
  end;

  function FindTagEnd(Start: Integer; AStr, AName: qiString): Integer;
  var
    I: Integer;
    buff: qiString;
    stt: TxmlTagState;
  begin
    Result := 0;
    I := Start;
    buff := EmptyStr;
    stt := tstWaitAttrName;
    while I < Length(AStr) do
    begin
      case stt of
        tstWaitAttrName:
          begin
            if (I + 1 < Length(AStr)) and
              (AStr[I] = sLt) and (AStr[I+1] = sSlash) then
            begin
              Result := I - 1;
              stt := tstReadAttrName;
              Inc(I);
            end;
            Inc(I);
            Continue;
          end;
       tstReadAttrName:
         begin
           if not QImport3Common.CharInSet(AStr[I], sWhiteSpaceName) then
           begin
             buff := buff + AStr[I];
             if CompareText(Trim(buff), AName) = 0 then
               Break;
           end;
           Inc(I);
           Continue;
         end;
      end;
    end;
  end;

  function ParseTagData(AName: qiString): TXMLTag;
  var
    TempData, TagEnd: qiString;
    EndData, K: Integer;
  begin
    Result := nil;
    if NoSchema and (FieldsAddedCount >= 0) then //if all the fields were added (if scheme not exists)
    begin
      if (FieldsAddedCount <> FieldNames.Count) then
      begin
        FieldsAddedCount := FieldNames.Count;
        Exit;
      end
      else begin
        FieldNames.Clear;
        GetFieldNames(FieldNames);
        FieldsAddedCount := -1;
        XMLFile.FPosition := FirstFieldPos; //go once again with filling data
        if FieldsOnly then Exit;
      end;
    end;
    EndData := FindTagEnd(XMLFile.FPosition, XML, AName);
    if EndData > 0 then
    begin
      TempData := Copy(XML, XMLFile.FPosition + 1, EndData - XMLFile.FPosition);
      databuf.Add(AName + '=' + TempData);
      attrnames.Add(AName);
      TagEnd := Copy(XML, EndData + 1, 100);
      EndData := EndData + Pos(AName, TagEnd) + Length(AName);
      XMLFile.FPosition := EndData;
      if CompareStr(AName, LastFieldName) = 0 then
      begin
        Result := RowsTag.Children.Add;
        Result.Name := sRow;
        for K := 0 to databuf.Count - 1 do
          Result.Attributes.Add(databuf[K]);
        for K := 0 to attrnames.Count - 1 do
          Result.FAttrNames.Add(attrnames[K]);
        databuf.Clear;
        attrnames.Clear;
      end;
    end;
  end;

  function ParseNoSchemaTag(AFieldName: QIString): TXMLTag;
  var
    InStr: Integer;
    SS, NoSpaces: QIString;
  begin
    Result := nil;
    NoSpaces := StringReplace(Copy(XML, XMLFile.FPosition - Length(AFieldName), Length(XML)),#32,'',[rfReplaceAll]);
    InStr := Pos(AFieldName, NoSpaces);
    if InStr > 0 then
    begin
      SS := Copy(NoSpaces, InStr + Length(AFieldName), Length(NoSpaces));
      if (SS[1] <> sGt) or (Pos(sSlash, AFieldName) = 1) then
        Exit
      else begin
        if (Pos(sGt, Copy(SS, 2, Length(SS))) > 0) and
          (Pos(sLt + sSlash + AFieldName, Copy(SS, 2, Length(SS))) < Pos(sGt, Copy(SS, 2, Length(SS)))) then
        begin
          Result := FieldsTag.Children.Add;
          Result.Name := sField;
          Result.Attributes.Add('FieldName=' + AFieldName);
          Result.Attributes.Add('DisplayLabel=' + AFieldName);
          Result.Attributes.Add('FieldType=varchar');
          Result.Attributes.Add('FieldClass="TField"');
          if FieldNames.IndexOf(AFieldName) = -1 then
            FieldNames.Add(AFieldName);
          if FirstFieldPos = 1 then
          begin
            FirstFieldPos := XMLFile.FPosition;
            FirstFieldName := AFieldName;
          end;
          ParseTagData(AFieldName);
        end;
      end;
    end;
  end;

begin
  Result := nil;
  st := stWaitTag;
  if not SingleTag then
  begin
    st := stWaitXMLDecl;
    XMLFile.FPosition := 1;
  end;
  FirstFieldPos := 1;
  buf := EmptyStr;
  FieldsAddedCount := 0;
  FieldNames := TqiStringList.Create;
  databuf := TqiStringList.Create;
  attrnames := TqiStringList.Create;
  try
    if not NoSchema then
      GetFieldNames(FieldNames);

    while XMLFile.FPosition < Length(XMLFile.FData) do
    begin
      ch := XML[XMLFile.FPosition];
      if FieldsOnly and (FieldsAddedCount = -1) then Exit;

      if (XMLFile.FPosition = 1) and (Pos(qiString('<?'), XML) > 1) then
      begin
        ch := XML[Pos(qiString('<?'), XML)];
        XMLFile.FPosition := Pos(qiString('<?'), XML);
      end;

      case st of
        stWaitXMLDecl:
          if QImport3Common.CharInSet(ch, sWhiteSpace) then
            st := stWaitXMLDecl
          else if ch = sLt then
          begin
            st := stReadXMLDecl;
            buf := EmptyStr;
            Inc(XMLFile.FPosition);
            Continue;
          end
          else begin
            XMLFile.FParsingFailed := True;
            Exit;
          end;

        stReadXMLDecl:
          if ch = sGt then
          begin
            Result := ParseNoSchemaTag(buf);
            buf := EmptyStr;
            Inc(XMLFile.FPosition);
            st := stWaitAccessDataRoot;
          end;

        stWaitAccessDataRoot:
          if ch = sGt then
          begin
            if (Pos(qiString('dataroot xmlns:od="urn:schemas-microsoft-com:officedata"'), buf) = 0) then
            begin
              XMLFile.FParsingFailed := True;
              Exit;
            end
            else begin
              buf := EmptyStr;
              Inc(XMLFile.FPosition);
              st := stWaitTag;
            end;
          end;

        stWaitTag:
          if QImport3Common.CharInSet(ch, sWhiteSpace) then
            st := stWaitTag
          else if ch = sLt then
          begin
            st := stReadTag;
            buf := EmptyStr;
            Inc(XMLFile.FPosition);
            Continue;
          end;

        stReadTag:
          if ch = sGt then
          begin
            if IsField(buf) then
            begin
              Result := ParseTagData(buf);
              if Assigned(Result) and SingleTag then
              begin
                Inc(XMLFile.FPosition);
                Exit;
              end;
            end
            else if NoSchema then
              Result := ParseNoSchemaTag(buf);
            buf := EmptyStr;
            st := stWaitTag;
          end;

        stBreak: Exit;
      end;

      buf := buf + ch;
      Inc(XMLFile.FPosition);

      if (XMLFile.FPosition = Length(XMLFile.FData)) and (FieldNames.Count > 0) and (FieldsAddedCount > 0) then
      begin
        FieldNames.Clear;
        GetFieldNames(FieldNames);
        FieldsAddedCount := -1;
        XMLFile.FPosition := FirstFieldPos;
        buf := FirstFieldName;
      end;
    end;
    XMLFile.FEof := true;
  finally
    if FieldsOnly then
      XMLFile.FParsingFailed := FieldsTag.Children.Count = 0
    else
      XMLFile.FParsingFailed := RowsTag.Children.Count = 0;
    FieldNames.Free;
    databuf.Free;
    attrnames.Free;
  end;
end;

end.

