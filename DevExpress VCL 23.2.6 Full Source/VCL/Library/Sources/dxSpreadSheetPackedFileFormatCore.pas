{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSpreadSheet                                       }
{                                                                    }
{           Copyright (c) 2001-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSSPREADSHEET CONTROL AND ALL    }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxSpreadSheetPackedFileFormatCore;

{$I cxVer.Inc}

interface

uses
  Windows, SysUtils, Classes, dxSpreadSheetCore, dxSpreadSheetClasses, dxZIPUtils, dxXMLDoc, dxCustomTree,
  dxSpreadSheetTypes, dxGDIPlusClasses;

type
  TdxSpreadSheetCustomPackedReader = class;
  TdxSpreadSheetCustomPackedWriter = class;

  { TdxSpreadSheetCustomPackedReader }

  TdxSpreadSheetCustomPackedReader = class(TdxSpreadSheetCustomReader)
  strict private
    FPackageReader: TdxZIPStreamReader;

    function CheckFileName(const AFileName: AnsiString): AnsiString;
  protected
    function FileExists(const AFileName: AnsiString): Boolean; overload;
    function FileExists(const AFileName: string): Boolean; overload;
    function ReadFile(const AFileName: AnsiString): TMemoryStream; overload; virtual;
    function ReadFile(const AFileName: string): TMemoryStream; overload;
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    destructor Destroy; override;
    //
    property PackageReader: TdxZIPStreamReader read FPackageReader;
  end;

  { TdxSpreadSheetCustomPackedWriter }

  TdxSpreadSheetCustomPackedWriter = class(TdxSpreadSheetCustomWriter)
  strict private
    FPackageWriter: TdxZIPStreamWriter;
  protected
    procedure WriteFile(const AFileName: string; AStream: TStream; AStreamOwnership: TStreamOwnership = soReference);
  public
    constructor Create(AOwner: TdxCustomSpreadSheet; AStream: TStream); override;
    destructor Destroy; override;
    //
    property PackageWriter: TdxZIPStreamWriter read FPackageWriter;
  end;

implementation

uses
  dxCore, dxSpreadSheetStrs, Math, dxSpreadSheetCoreStrs;

const
  dxThisUnitName = 'dxSpreadSheetPackedFileFormatCore';

{ TdxSpreadSheetCustomPackedReader }

constructor TdxSpreadSheetCustomPackedReader.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  inherited Create(AOwner, AStream);
  FPackageReader := TdxZIPStreamReader.Create(Stream);
end;

destructor TdxSpreadSheetCustomPackedReader.Destroy;
begin
  FreeAndNil(FPackageReader);
  inherited Destroy;
end;

function TdxSpreadSheetCustomPackedReader.FileExists(const AFileName: string): Boolean;
begin
  Result := FileExists(dxStringToAnsiString(AFileName));
end;

function TdxSpreadSheetCustomPackedReader.FileExists(const AFileName: AnsiString): Boolean;
begin
  Result := PackageReader.Exists(CheckFileName(AFileName));
end;

function TdxSpreadSheetCustomPackedReader.ReadFile(const AFileName: string): TMemoryStream;
begin
  Result := ReadFile(dxStringToAnsiString(AFileName));
end;

function TdxSpreadSheetCustomPackedReader.ReadFile(const AFileName: AnsiString): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  try
    if PackageReader.Extract(CheckFileName(AFileName), Result) then
      Result.Position := 0
    else
      DoError(sdxErrorFileCannotBeFoundInPackage, [AFileName], ssmtError);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TdxSpreadSheetCustomPackedReader.CheckFileName(const AFileName: AnsiString): AnsiString;
begin
  if (AFileName <> '') and (AFileName[1] = '.') then
    Result := Copy(AFileName, 2, MaxInt)
  else
    Result := AFileName;
end;

{ TdxSpreadSheetCustomPackedWriter }

constructor TdxSpreadSheetCustomPackedWriter.Create(AOwner: TdxCustomSpreadSheet; AStream: TStream);
begin
  inherited Create(AOwner, AStream);
  FPackageWriter := TdxZIPStreamWriter.Create(Stream);
end;

destructor TdxSpreadSheetCustomPackedWriter.Destroy;
begin
  FreeAndNil(FPackageWriter);
  inherited Destroy;
end;

procedure TdxSpreadSheetCustomPackedWriter.WriteFile(
  const AFileName: string; AStream: TStream; AStreamOwnership: TStreamOwnership);
begin
  PackageWriter.AddFile(dxStringToAnsiString(AFileName), AStream, AStreamOwnership = soOwned);
end;

end.
