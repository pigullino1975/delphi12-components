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

unit dxSpreadSheetFormatXLSX;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxCore;

const
  dxXLSXMaxColumnIndex = dxSpreadSheetMaxColumnCount - 1;
  dxXLSXMaxRowIndex = dxSpreadSheetMaxRowCount - 1;

type

  { TdxSpreadSheetXLSXFormat }

  TdxSpreadSheetXLSXFormat = class(TdxSpreadSheetCustomFormat)
  public
    class function CanReadFromStream(AStream: TStream): Boolean; override;
    class function CreateFormatSettings: TdxSpreadSheetFormatSettings; override;
    class function CreateReader(ASpreadSheet: TdxCustomSpreadSheet; AStream: TStream): TdxSpreadSheetCustomReader; override;
    class function GetDescription: string; override;
    class function GetExt: string; override;
    class function GetReader: TdxSpreadSheetCustomReaderClass; override;
    class function GetWriter: TdxSpreadSheetCustomWriterClass; override;
  end;

  { TdxSpreadSheetXLTXFormat }

  TdxSpreadSheetXLTXFormat = class(TdxSpreadSheetXLSXFormat)
  public
    class function GetDescription: string; override;
    class function GetExt: string; override;
    class function GetWriter: TdxSpreadSheetCustomWriterClass; override;
  end;

implementation

uses
  AnsiStrings, cxGraphics, cxGeometry, dxZIPUtils, dxOLECryptoContainer, dxCoreGraphics,
  dxSpreadSheetFormatXLSXReader, dxSpreadSheetFormatXLSXWriter, dxSpreadSheetUtils, dxSpreadSheetFormatUtils,
  dxDPIAwareUtils, dxSpreadSheetFormatXLSXUtils;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSX';

type
  TdxSpreadSheetAccess = class(TdxCustomSpreadSheet);

{ TdxSpreadSheetXLSXFormat }

class function TdxSpreadSheetXLSXFormat.CanReadFromStream(AStream: TStream): Boolean;
var
  AFileName: string;
  AReader: TdxSpreadSheetXLSXReader;
  ARels: TdxXLSXRelationships;
  ASavedPosition: Int64;
begin
  ASavedPosition := AStream.Position;
  try
    Result := TdxOLECryptoContainer.IsOurStream(AStream);
    if not Result then
    try
      AReader := TdxSpreadSheetXLSXReader.Create(nil, AStream);
      try
        AReader.IgnoreMessages := [Low(TdxSpreadSheetMessageType)..High(TdxSpreadSheetMessageType)];
        ARels := AReader.GetFileRelationships('');
        try
          Result := AReader.FindWorkbookFileName(ARels, AFileName);
        finally
          ARels.Free;
        end;
      finally
        AReader.Free;
      end;
    except
      Result := False;
    end;
  finally
    AStream.Position := ASavedPosition;
  end;
end;

class function TdxSpreadSheetXLSXFormat.CreateFormatSettings: TdxSpreadSheetFormatSettings;
begin
  Result := TdxSpreadSheetFormatSettings.Create;
end;

class function TdxSpreadSheetXLSXFormat.CreateReader(
  ASpreadSheet: TdxCustomSpreadSheet; AStream: TStream): TdxSpreadSheetCustomReader;
var
  APassword: string;
begin
  APassword := ASpreadSheet.Password;
  if TdxOLECryptoContainer.Decrypt(AStream, AStream, APassword,
    function (var APassword: string): Boolean
    begin
      if APassword <> dxSpreadSheetDefaultPassword then
      begin
        APassword := dxSpreadSheetDefaultPassword;
        Result := True;
      end
      else
        Result := TdxSpreadSheetAccess(ASpreadSheet).DoGetPassword(APassword);
    end, 2)
  then
    begin
      Result := GetReader.Create(ASpreadSheet, AStream);
      Result.StreamAutoFree := True;
    end
    else
      Result := inherited CreateReader(ASpreadSheet, AStream);
end;

class function TdxSpreadSheetXLSXFormat.GetDescription: string;
begin
  Result := 'Excel Workbook';
end;

class function TdxSpreadSheetXLSXFormat.GetExt: string;
begin
  Result := '.xlsx';
end;

class function TdxSpreadSheetXLSXFormat.GetReader: TdxSpreadSheetCustomReaderClass;
begin
  Result := TdxSpreadSheetXLSXReader;
end;

class function TdxSpreadSheetXLSXFormat.GetWriter: TdxSpreadSheetCustomWriterClass;
begin
  Result := TdxSpreadSheetXLSXWriter;
end;

{ TdxSpreadSheetXLTXFormat }

class function TdxSpreadSheetXLTXFormat.GetDescription: string;
begin
  Result := 'Excel Template';
end;

class function TdxSpreadSheetXLTXFormat.GetExt: string;
begin
  Result := '.xltx';
end;

class function TdxSpreadSheetXLTXFormat.GetWriter: TdxSpreadSheetCustomWriterClass;
begin
  Result := TdxSpreadSheetXLTXWriter;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetXLSXFormat.Register;
  TdxSpreadSheetXLTXFormat.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSpreadSheetXLTXFormat.Unregister;
  TdxSpreadSheetXLSXFormat.Unregister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
