{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           GDI+ Library                                             }
{                                                                    }
{           Copyright (c) 2002-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
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

unit dxSmartImageExporter;

{$I cxVer.inc}
{$R dxSmartImageExporter.res}

interface

uses
  SysUtils, Classes, dxCore, cxClasses, dxGDIPlusClasses, dxZIPUtils;

type
  { TdxSmartImageExporter }

  TdxSmartImageExporter = class abstract
  protected
    class function GetExtensions: TArray<string>; virtual;
    class function IsValidExtension(const AExt: string): Boolean;
  public
    procedure Export(const AStream: TStream; AImage: TdxSmartImage); overload; virtual;
  end;
  TdxSmartImageExporterClass = class of TdxSmartImageExporter;

  { TdxSmartImageDocumentExporter }

  TdxSmartImageDocumentExporter = class abstract(TdxSmartImageExporter)
  private const
    PixelsToEMUCoefficient = 9525;
  private
    FImage: TdxSmartImage;
    FItemFileName: string;
    FItemStream: TMemoryStream;
    FItemReader: TdxZIPStreamReader;
    FItemWriter: TdxZIPStreamWriter;

    function PixelsToEMU(AValueInPixels: Integer): Integer;
  protected
    function GetResourceName: string; virtual;
    function GetDrawingFileName: string; virtual; abstract;
    function GetImageFileName: string; virtual;
    function GetDefaultImageWidth: Integer; virtual; abstract;
    function GetDefaultImageHeight: Integer; virtual; abstract;
    function CreateItemStream: TMemoryStream; virtual;
    procedure CorrectImageSize(var AImageWidthEMU, AImageHeightEMU: Integer); virtual;
    procedure ReadItem; virtual;
    procedure ModifyItem; virtual;
    procedure WriteItem; virtual;
  public
    procedure Export(const AStream: TStream; AImage: TdxSmartImage); override;
  end;

  { TdxSmartImageDOCXExporter }

  TdxSmartImageDOCXExporter = class(TdxSmartImageDocumentExporter)
  private const
    // Sizes in English Metric Units for Landscape page orientation and 1 inch margins
    MaxImageTransversalSizeEMU = 5907405; // 620px; 16.3432cm
    MaxImageLongitudinalEMU = 8215630; // 862px; 22.72232cm
  protected
    class function GetExtensions: TArray<string>; override;
    function GetDrawingFileName: string; override;
    function GetDefaultImageWidth: Integer; override;
    function GetDefaultImageHeight: Integer; override;
    procedure CorrectImageSize(var AImageWidth, AImageHeight: Integer); override;
  end;

  { TdxSmartImageXLSXExporter }

  TdxSmartImageXLSXExporter = class(TdxSmartImageDocumentExporter)
  private const
    // Sizes in English Metric Units
    DefaultImageWidthEMU = 1000000;
    DefaultImageHeightEMU = 2000000;
  protected
    class function GetExtensions: TArray<string>; override;
    function GetDrawingFileName: string; override;
    function GetDefaultImageWidth: Integer; override;
    function GetDefaultImageHeight: Integer; override;
  end;

  { TdxSmartImageExporters }

  TdxSmartImageExporters = class(TcxRegisteredClasses) // for internal use
  protected
    procedure ThrowUnsupportedFormatException;
  public
    function GetExporter(const AFileName: string): TdxSmartImageExporterClass;
    procedure Initialize;
    procedure Finalize;

    procedure Export(const AFileName: string; AImage: TdxSmartImage); overload;
    procedure Export(const AStream: TStream; AExporterClass: TdxSmartImageExporterClass; AImage: TdxSmartImage); overload;
  end;

var
  dxSmartImageExporters: TdxSmartImageExporters;

implementation

uses
  Windows, IOUtils, StrUtils;

const
  dxThisUnitName = 'dxChartExporter';

{ TdxSmartImageExporter }

procedure TdxSmartImageExporter.Export(const AStream: TStream; AImage: TdxSmartImage);
begin
  dxSmartImageExporters.ThrowUnsupportedFormatException;
end;

class function TdxSmartImageExporter.GetExtensions: TArray<string>;
begin
  Result := nil;
end;

class function TdxSmartImageExporter.IsValidExtension(const AExt: string): Boolean;
var
  I: Integer;
  AExtensions: TArray<string>;
begin
  AExtensions := GetExtensions;
  for I := Low(AExtensions) to High(AExtensions) do
    if LowerCase(AExtensions[I]) = LowerCase(AExt) then
      Exit(True);
  Result := False;
end;

{ TdxSmartImageDocumentExporter }

function TdxSmartImageDocumentExporter.PixelsToEMU(AValueInPixels: Integer): Integer;
begin
  Result := AValueInPixels * PixelsToEMUCoefficient;
end;

function TdxSmartImageDocumentExporter.GetResourceName: string;
begin
  Result := 'WorkPiece' + GetExtensions[0];
end;

function TdxSmartImageDocumentExporter.GetImageFileName: string;
begin
  Result := 'image1.png';
end;

procedure TdxSmartImageDocumentExporter.CorrectImageSize(var AImageWidthEMU, AImageHeightEMU: Integer);
begin
  //
end;

function TdxSmartImageDocumentExporter.CreateItemStream: TMemoryStream;
begin
  if ContainsText(FItemFileName, GetDrawingFileName) then
    Result := TStringStream.Create
  else
    Result := TMemoryStream.Create;
end;

procedure TdxSmartImageDocumentExporter.Export(const AStream: TStream; AImage: TdxSmartImage);
var
  AResourceStream: TResourceStream;
  I: Integer;
begin
  FImage := AImage;
  AResourceStream := TResourceStream.Create(HInstance, GetResourceName, RT_RCDATA);
  FItemReader := TdxZIPStreamReader.Create(AResourceStream);
  FItemWriter := TdxZIPStreamWriter.Create(AStream);
  try
    for I := 0 to FItemReader.Files.Count - 1 do
    begin
      FItemFileName := string(FItemReader.Files[I].Name);
      FItemStream := CreateItemStream;
      try
        ReadItem;
        ModifyItem;
        WriteItem;
      finally
        FItemStream.Free;
      end;
    end;
  finally
    FItemWriter.Free;
    FItemReader.Free;
    AResourceStream.Free;
  end;
end;

procedure TdxSmartImageDocumentExporter.ReadItem;
begin
  FItemReader.Extract(AnsiString(FItemFileName), FItemStream);
end;

procedure TdxSmartImageDocumentExporter.ModifyItem;
var
  AStringStream: TStringStream;
  AXMLString: string;
  AImageWidth, AImageHeight: Integer;
begin
  if ContainsText(FItemFileName, GetDrawingFileName) then
  begin
    AStringStream := FItemStream as TStringStream;
    AXMLString := AStringStream.DataString;

    AImageWidth := PixelsToEMU(FImage.Width);
    AImageHeight := PixelsToEMU(FImage.Height);

    CorrectImageSize(AImageWidth, AImageHeight);

    AXMLString := ReplaceText(AXMLString, '"' + IntToStr(GetDefaultImageWidth) + '"',
      '"' + IntToStr(AImageWidth) + '"');
    AXMLString := ReplaceText(AXMLString, '"' + IntToStr(GetDefaultImageHeight) + '"',
      '"' + IntToStr(AImageHeight) + '"');

    AStringStream.Clear;
    AStringStream.WriteString(AXMLString);
  end
  else
    if ContainsText(FItemFileName, GetImageFileName) then
      FImage.SaveToStreamByCodec(FItemStream, TdxGPImageCodecPNG);
end;

procedure TdxSmartImageDocumentExporter.WriteItem;
begin
  FItemWriter.AddFile(AnsiString(FItemFileName), FItemStream);
end;

{ TdxSmartImageDOCXExporter }

procedure TdxSmartImageDOCXExporter.CorrectImageSize(var AImageWidth, AImageHeight: Integer);
var
  ADefaultImageWidth, ADefaultImageHeight: Integer;
begin
  ADefaultImageWidth := GetDefaultImageWidth;
  ADefaultImageHeight := GetDefaultImageHeight;

  if AImageWidth > ADefaultImageWidth then
  begin
    AImageHeight := Round(AImageHeight * (ADefaultImageWidth / AImageWidth));
    AImageWidth := ADefaultImageWidth;
  end;
  if AImageHeight > ADefaultImageHeight then
  begin
    AImageWidth := Round(AImageWidth * (ADefaultImageHeight / AImageHeight));
    AImageHeight := ADefaultImageHeight;
  end;
end;

function TdxSmartImageDOCXExporter.GetDefaultImageHeight: Integer;
begin
  Result := MaxImageLongitudinalEMU;
end;

function TdxSmartImageDOCXExporter.GetDefaultImageWidth: Integer;
begin
  Result := MaxImageTransversalSizeEMU;
end;

function TdxSmartImageDOCXExporter.GetDrawingFileName: string;
begin
  Result := 'document.xml';
end;

class function TdxSmartImageDOCXExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.docx');
end;

{ TdxSmartImageXLSXExporter }

function TdxSmartImageXLSXExporter.GetDefaultImageHeight: Integer;
begin
  Result := DefaultImageHeightEMU;
end;

function TdxSmartImageXLSXExporter.GetDefaultImageWidth: Integer;
begin
  Result := DefaultImageWidthEMU;
end;

function TdxSmartImageXLSXExporter.GetDrawingFileName: string;
begin
  Result := 'drawing1.xml';
end;

class function TdxSmartImageXLSXExporter.GetExtensions: TArray<string>;
begin
  Result := TArray<string>.Create('.xlsx');
end;

{ TdxSmartImageExporters }

function TdxSmartImageExporters.GetExporter(const AFileName: string): TdxSmartImageExporterClass;
var
  I: Integer;
  AExt: string;
begin
  AExt := LowerCase(TPath.GetExtension(AFileName));
  for I := 0 to Count - 1 do
    if TdxSmartImageExporter(Items[I]).IsValidExtension(AExt) then
      Exit(TdxSmartImageExporterClass(Items[I]));
  Result := nil;
end;

procedure TdxSmartImageExporters.Initialize;
begin
  Register(TdxSmartImageDOCXExporter, TdxSmartImageDOCXExporter.GetExtensions[0]);
  Register(TdxSmartImageXLSXExporter, TdxSmartImageXLSXExporter.GetExtensions[0]);
end;

procedure TdxSmartImageExporters.Export(const AFileName: string; AImage: TdxSmartImage);
var
  AExporterClass: TdxSmartImageExporterClass;
  AStream: TStream;
begin
  AExporterClass := GetExporter(AFileName);
  if AExporterClass = nil then
    ThrowUnsupportedFormatException;
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    Export(AStream, AExporterClass, AImage);
  finally
    AStream.Free;
  end;
end;

procedure TdxSmartImageExporters.Export(const AStream: TStream; AExporterClass: TdxSmartImageExporterClass; AImage: TdxSmartImage);
var
  AExporter: TdxSmartImageExporter;
begin
  AExporter := AExporterClass.Create;
  try
    AExporter.Export(AStream, AImage);
  finally
    AExporter.Free;
  end;
end;

procedure TdxSmartImageExporters.Finalize;
begin
  Unregister(TdxSmartImageDOCXExporter);
  Unregister(TdxSmartImageXLSXExporter);
end;

procedure TdxSmartImageExporters.ThrowUnsupportedFormatException;
begin
  EdxException.Create('The file format is not supported');
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxSmartImageExporters := TdxSmartImageExporters.Create;
  dxSmartImageExporters.Initialize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}

finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxSmartImageExporters.Finalize;
  dxSmartImageExporters.Free;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}

end.
