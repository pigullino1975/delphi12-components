unit QImport3ZipFile;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF RTLZIP}
    System.Classes,
    System.SysUtils,
    System.Zip;
  {$ELSE}
    QImport3ZipMcpt;
  {$ENDIF}

type
  TQImport3ZipFile = class
  public
    class procedure Extract(const AZipFileName, APath: string);
  end;

implementation

{ TQImport3ZipFile }

class procedure TQImport3ZipFile.Extract(const AZipFileName, APath: string);
var
{$IFDEF RTLZIP}
  ZipFile: TZipFile;
  LFileStream: TFileStream;
{$ELSE}
  ZipFile: TMiniZip;
{$ENDIF}
begin
{$IFDEF RTLZIP}
  // not use TZipFile.ExtractZipFile(AZipFileName, APath). it uses fmOpenRead or fmShareDenyWrite file access mode
  LFileStream := TFileStream.Create(AZipFileName, fmOpenRead or fmShareDenyNone);
  try
    ZipFile := TZipFile.Create;
    try
      ZipFile.Open(LFileStream, zmRead);
      ZipFile.ExtractAll(APath);
      ZipFile.Close;
    finally
      ZipFile.Free;
    end;
  finally
    FreeAndNil(LFileStream);
  end;
{$ELSE}
  ZipFile := TMiniZip.Create(nil);
  try
    ZipFile.UnZipfile := AZipFileName;
    ZipFile.UnzipAllTo(APath);
  finally
    ZipFile.Free;
  end;
{$ENDIF}
end;

end.
