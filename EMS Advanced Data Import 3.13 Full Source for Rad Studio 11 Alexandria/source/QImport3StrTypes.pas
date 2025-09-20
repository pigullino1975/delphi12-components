unit QImport3StrTypes;

{$I QImport3VerCtrl.Inc}

interface

uses
{$IFDEF VCL16}
  {$IFNDEF QI_UNICODE}
    System.Classes,
  {$ENDIF}
  {$IFNDEF NOGUI}
    {$IFDEF WIN64}
      Vcl.Grids,
    {$ELSE}
      QImport3WideStringGrid,
    {$ENDIF}
  {$ENDIF}
  System.WideStrings;
{$ELSE}
  {$IFNDEF QI_UNICODE}
    Classes,
  {$ENDIF}
  {$IFNDEF NOGUI}
    {$IFDEF QI_UNICODE}
      QImport3WideStringGrid,
    {$ELSE}
      Grids,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF VCL10}
    WideStrings;
  {$ELSE}
    QImport3WideStrings;
  {$ENDIF}
{$ENDIF}

type
{$IFDEF QI_UNICODE}
  qiString = WideString;
  qiChar = WideChar;
  PqiChar = PWideChar;
  TqiStrings = TWideStrings;
  TqiStringList = TWideStringList;
  {$IFNDEF NOGUI}
  TqiStringGrid = {$IFDEF WIN64}TStringGrid{$ELSE}TEmsWideStringGrid{$ENDIF};
  {$ENDIF}
{$ELSE}
  qiString = string;
  qiChar = Char;
  PqiChar = PChar;
  TqiStrings = TStrings;
  TqiStringList = TStringList;
  {$IFNDEF NOGUI}
  TqiStringGrid = TStringGrid;
  {$ENDIF}
{$ENDIF}

implementation

end.
