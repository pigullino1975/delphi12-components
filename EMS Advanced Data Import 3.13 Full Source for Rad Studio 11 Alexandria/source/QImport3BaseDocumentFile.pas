unit QImport3BaseDocumentFile;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    System.SysUtils,
    System.Classes,
    Winapi.Windows,
  {$ELSE}
    Classes,
    SysUtils,
    Windows,
  {$ENDIF}
    QImport3StrTypes,
    QImport3Encoding;

const
  cBufferSize = 128;
  sDefaultXPath = '/';

type
  TBaseDocumentFile = class
  private
    FFileName: qiString;
    FLoaded: Boolean;
    FMaxRowCount: Integer;
  protected
    procedure DoAfterLoad; virtual;
    procedure DoBeforeLoad; virtual;
    procedure DoLoad; virtual;
    procedure SetFileName(const Value: qiString); virtual;
    procedure SetMaxRowCount(const Value: Integer); virtual;
  public
    constructor Create; virtual;
    procedure Load;
    procedure Clear; virtual;
    property Loaded: Boolean read FLoaded;
    property FileName: qiString read FFileName write SetFileName;
    property MaxRowCount: Integer read FMaxRowCount write SetMaxRowCount;
  end;

const
  sFileNameNotDefined = 'File name is not defined';
  sFileNotFound = 'File %s not found';

implementation

const
  LF = #13#10;

{ TBaseDocumentFile }

procedure TBaseDocumentFile.SetFileName(const Value: qiString);
begin
  if FFileName <> Value then;
  begin
    FFileName := Value;
    FLoaded := False;
  end;
end;

procedure TBaseDocumentFile.SetMaxRowCount(const Value: Integer);
begin
  FMaxRowCount := Value;
end;

constructor TBaseDocumentFile.Create;
begin
  FLoaded := False;
end;

procedure TBaseDocumentFile.Load;
begin
  DoBeforeLoad;
  try
    if not FLoaded then
      DoLoad;
  finally
    DoAfterLoad;
  end;
end;

procedure TBaseDocumentFile.Clear;
begin
  FFileName := '';
  FLoaded := False;
end;

procedure TBaseDocumentFile.DoAfterLoad;
begin

end;

procedure TBaseDocumentFile.DoBeforeLoad;
begin
  if FFileName = EmptyStr then
    raise Exception.Create(sFileNameNotDefined);
  if not FileExists(FFileName) then
    raise Exception.CreateFmt(sFileNotFound, [FFileName]);
end;

procedure TBaseDocumentFile.DoLoad;
begin
  FLoaded := True;
end;

end.

