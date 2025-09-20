unit QImport3ScriptEngine;
{$I QImport3VerCtrl.Inc}

interface

{$IFDEF USESCRIPT}
uses
  {$IFDEF VCL16}
    System.SysUtils,
    System.Classes,
    System.Variants,
    System.StrUtils,
    Data.Db,
  {$ELSE}
    SysUtils,
    Classes,
    {$IFDEF VCL7}
      Variants,
    {$ENDIF}
    StrUtils,
    DB,
  {$ENDIF}
  QImport3StrTypes,
  QImport3Common;

type
  TScriptErrorMsg = packed record
    Line,
    Column,
    ErrorCode: Integer;
    ErrorDescription,
    SourceText: qiString;
  end;

  TQImport3ScriptEngine = class(TComponent)
  private
    FScript: qiString;
    FInputValue: Variant;
    FInputValueFlag: qiString;
    FResultValue: Variant;
    FLastError: TScriptErrorMsg;
    FInputType: TFieldType;
    function GetInputValueAsString: String;
    procedure SetInputValueAsString(const Value: String);
    function GetInputValueAsInteger: Integer;
    procedure SetInputValueAsInteger(const Value: Integer);
    function GetInputValueAsWideString: WideString;
    procedure SetInputValueAsWideString(const Value: WideString);
    function DoubleQuote(const Value: qiString;
      const QuoteChar: qiChar): qiString;
  protected
    function GetInputValueForScript: qiString; virtual;
    property InputValueAsString: String read GetInputValueAsString
      write SetInputValueAsString;
    property InputValueAsWideString: WideString read GetInputValueAsWideString
      write SetInputValueAsWideString;
    property InputValueAsInteger: Integer read GetInputValueAsInteger
      write SetInputValueAsInteger;
    function QuoteStringValue(const Value: qiString;
      const QuoteChar: qiChar): qiString; overload;
    function RunScript(const ScriptText: qiString): Variant; virtual; abstract;
    function GetError: TScriptErrorMsg; virtual; abstract;
    function QuoteStringValue(const Value: qiString): qiString; overload; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    property ResultValue: Variant read FResultValue;
    property LastError: TScriptErrorMsg read FLastError;
    property InputType: TFieldType read FInputType write FInputType;
    function Execute: Boolean;
  published
    property Script: qiString read FScript write FScript;
    property InputValue: Variant read FInputValue write FInputValue;
    property InputValueFlag: qiString read FInputValueFlag write FInputValueFlag;
  end;
{$ENDIF}

implementation

{$IFDEF USESCRIPT}

{ TQImport3ScriptEngine }

constructor TQImport3ScriptEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInputType := ftUnknown;
end;

function TQImport3ScriptEngine.DoubleQuote(const Value: qiString;
  const QuoteChar: qiChar): qiString;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
    if Value[I] = QuoteChar then
      Result := Result + QuoteChar + QuoteChar
    else
      Result := Result + Value[I];
end;

function TQImport3ScriptEngine.Execute: Boolean;
var
  ScriptText: qiString;
begin
  ScriptText := StringReplace(FScript, FInputValueFlag, GetInputValueForScript, [rfReplaceAll]);
  try
    FResultValue := RunScript(ScriptText);
    Result := True;
  except
    Result := False;
  end;
  FLastError := GetError;
end;

function TQImport3ScriptEngine.GetInputValueAsInteger: Integer;
begin
  try
    Result := FInputValue;
  except
    Result := 0;
  end;
end;

function TQImport3ScriptEngine.GetInputValueAsString: String;
begin
  Result := VarToStrDef(FInputValue, '');
end;

function TQImport3ScriptEngine.GetInputValueAsWideString: WideString;
begin
  Result := VarToWideStrDef(FInputValue, '');
end;

function TQImport3ScriptEngine.GetInputValueForScript: qiString;
begin
  case VarType(FInputValue) of
    vtChar,
    vtString,
    vtAnsiString:
      Result := QuoteStringValue(InputValueAsString);
    vtWideChar,
    vtWideString:
      Result := QuoteStringValue(InputValueAsWideString);
    vtInteger:
      Result := FInputValue;
  else
    case FInputType of
    ftInteger, ftSmallInt, ftLargeInt:
      Result := GetNumericString(InputValueAsString);
    ftDateTime, ftTime {$IFDEF VCL6}, ftTimestamp{$ENDIF}:
      Result := InputValueAsString;
    ftFloat, ftCurrency, ftBCD {$IFDEF VCL6}, ftFmtBCD{$ENDIF}:
      Result := StringReplace(GetNumericString(InputValueAsString),',','.',[]);
    else
      Result := QuoteStringValue(InputValueAsString);
    end;
  end;
end;

function TQImport3ScriptEngine.QuoteStringValue(const Value: qiString;
  const QuoteChar: qiChar): qiString;
var
  LengthValue: Integer;
begin
  Result := Value;
  LengthValue := Length(Result);
  if LengthValue > 0 then
    if not((Result[1] = QuoteChar) and (Result[LengthValue] = QuoteChar) ) then
    begin
      Result := DoubleQuote(Result, QuoteChar);
      Result := QuoteChar + Result + QuoteChar;
    end;
end;


procedure TQImport3ScriptEngine.SetInputValueAsInteger(const Value: Integer);
begin
  if InputValueAsInteger <> Value then
    FInputValue := Value;
end;

procedure TQImport3ScriptEngine.SetInputValueAsString(const Value: String);
begin
  if InputValueAsString <> Value then
    FInputValue := Value;
end;

procedure TQImport3ScriptEngine.SetInputValueAsWideString(const Value: WideString);
begin
  if InputValueAsWideString <> Value then
    FInputValue := Value;
end;
{$ENDIF}

end.
