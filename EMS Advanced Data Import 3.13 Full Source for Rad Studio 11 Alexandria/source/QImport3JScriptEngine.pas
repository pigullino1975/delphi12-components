unit QImport3JScriptEngine;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF USESCRIPT}
uses
  {$IFDEF VCL16}
    System.Classes,
    System.SysUtils,
    System.DateUtils,
    Data.DB,
    System.Win.ComObj,
  {$ELSE}
    Classes,
    SysUtils,
    DateUtils,
    DB,
    ComObj,
  {$ENDIF}
  QImport3ScriptEngine,
  QImport3StrTypes,
  QImport3MSScriptControlTLB,
  QImport3Common;

type
  TQImport3JScriptEngine = class(TQImport3ScriptEngine)
  private
    FLastError: TScriptErrorMsg;
  protected
    function GetInputValueForScript: qiString; override;
    function RunScript(const ScriptText: qiString): Variant; override;
    function GetError: TScriptErrorMsg; override;
    function QuoteStringValue(const Value: qiString): qiString; override;
    function ConvertToJSDate: qiString;
  end;
{$ENDIF}

implementation

{$IFDEF USESCRIPT}

{ TQImport3JScriptEngine }

function TQImport3JScriptEngine.ConvertToJSDate: qiString;
var
  D: TDateTime;
begin
  if TryStrToDateTime(InputValue, D) then
    Result := 'new Date(' +
    IntToStr(YearOf(D)) + ',' + IntToStr(MonthOf(D)) + ',' + IntToStr(DayOf(D)) +
    ',' + IntToStr(HourOf(D)) + ',' + IntToStr(MinuteOf(D)) + ',' + IntToStr(SecondOf(D)) +
      ',' +IntToStr(MilliSecondOf(D)) + ')'
   else begin
     InputType := ftUnknown;
     Result := InputValue;
   end;
end;

function TQImport3JScriptEngine.GetError: TScriptErrorMsg;
begin
  Result := FLastError;
end;


function TQImport3JScriptEngine.GetInputValueForScript: qiString;
begin
  if InputType in [ftDateTime, ftDate, ftTime{$IFDEF VCL6}, ftTimeStamp{$ENDIF}] then
    Result := ConvertToJSDate
  else
    Result := inherited GetInputValueForScript;
end;

function TQImport3JScriptEngine.QuoteStringValue(
  const Value: qiString): qiString;
const
  QuoteChar = '"';
begin
  Result := QuoteStringValue(Value, QuoteChar)
end;

function TQImport3JScriptEngine.RunScript(const ScriptText: qiString): Variant;
var
  LScriptControl: IScriptControl;
begin
  LScriptControl := CreateComObject(CLASS_ScriptControl) as IScriptControl;
  try
    LScriptControl.Language := 'JScript';
    try
      Result := LScriptControl.Eval(ScriptText);
    except
      FLastError.Line := LScriptControl.Error.Line;
      FLastError.Column := LScriptControl.Error.Column;
      FLastError.ErrorCode := LScriptControl.Error.Number;
      FLastError.ErrorDescription := LScriptControl.Error.Description;
      FLastError.SourceText := LScriptControl.Error.Text;
      raise;
    end;
  finally
    LScriptControl := nil;
  end;
end;
{$ENDIF}

end.
